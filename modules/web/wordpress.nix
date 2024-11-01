{ config, lib, pkgs, ... }:
#TODO: 
# nginx caching
# automate some installation and config processes:
# detect hostname changes (bind hostname to wordpress conifg somehow)
# - Create root folder if not exists and add install script that does the following (using wp-cli)
#   - helps setting mysql password
#   - downloads latest wordpress
#   - fills up wp-config.php
let
  cfg = config.services.custom.web.wordpress;
  takeLast = with lib; n: list: reverseList (take n (reverseList list));
  getSecondLast = with builtins; list: elemAt list (length list - 2);
  getDomain = with lib; host: 
    concatStringsSep "." (takeLast 2 (splitString "." host));
  getBasename = with lib; host: getSecondLast (splitString "." host);
  siteOptions = { lib, config, ... }:
    let cfg = config;
    in {
      options = with lib; {
        logFilePrefix = mkOption {
          type = types.str;
          description = ''
            The log filename prefix. Logs will be stored in 
            `/var/log/nginx/<logFolder>-error.log` and
            `/var/log/nginx/<logFolder>-access.log`
            Defaults to appName option.
            '';
        };
        errorLogFile = mkOption {
          type = types.str;
          description = "Error log path."; 
          readOnly = true;
        };
        accessLogFile = mkOption {
          type = types.str;
          description = "Error log path."; 
          readOnly = true;
        };
        host = mkOption {
          type = types.str;
          example = "sub.domain.com";
          description = "The hostname of the wordpress site.";
        };
        domain = mkOption {
          type = types.str;
          description = ''
            The domain of the hostname. Automatically extracted by the module.
          '';
          readOnly = true;
        };
        basename = mkOption {
          type = types.str;
          description = ''
            The basename of the hostname. Automatically extracted by the module.
          '';
          readOnly = true;
        };
        appName = mkOption {
          type = types.str;
          description = ''
            Name used for:
              - the user that runs php-fpm
              - the mariadb database name
              - the php-fpm service name: php-fpm-<appName>
            Defaults to 'wp<basename>'.
          '';
        };
        root = mkOption {
          type = types.str;
          description =
            "Wordpress root folder. Default /var/www/wordpress/<host>.";
        };
        ACMEHost = mkOption {
          type = types.str;
          description = ''
            The ACME host to use for SSL. Defaults to the wordpress domain
            (calculated automatically from the host).
          '';
        };
        max_upload_filesize = mkOption {
          type = types.numbers.positive;
          default = 50;
          description = "The maximum upload file size in MB.";
        };
      };
      config = {
        # TODO: use submodule attr name to set host default
        root = lib.mkDefault "/var/www/wordpress/${cfg.host}";
        domain = getDomain cfg.host;
        basename = getBasename cfg.host;
        appName = lib.mkDefault "wp${cfg.basename}";
        logFilePrefix = lib.mkDefault cfg.appName;
        errorLogFile = "/var/log/nginx/${cfg.logFilePrefix}-error.log";
        accessLogFile = "/var/log/nginx/${cfg.logFilePrefix}-access.log";
        ACMEHost = lib.mkDefault cfg.domain;
      };
    };
in {
  options = {
    services.custom.web.wordpress = with lib; {
      sites = mkOption {
        type = types.attrsOf (types.submodule siteOptions);
        default = { };
        description = "Wordpress sites configurations";
      };
    };
  };

  config.services.nginx = lib.mkMerge (lib.mapAttrsToList (name: cfg: {
    upstreams."php-${cfg.appName}".servers."unix:${
      config.services.phpfpm.pools.${cfg.appName}.socket
    }" = { };
    # additionalModules = [ pkgs.nginxModules.cache-purge ]; # TODO: Configurar cache
    virtualHosts."${cfg.host}" = {
      root = cfg.root;
      useACMEHost = cfg.ACMEHost;
      forceSSL = true;
      extraConfig = ''
        index index.php index.html;
        error_log ${cfg.errorLogFile} warn;
        access_log ${cfg.accessLogFile};
        client_max_body_size ${builtins.toString cfg.max_upload_filesize}M;
      '';
      locations = {
        "/".extraConfig = ''
          try_files $uri $uri/ /index.php?$args;
        '';
        "~ .php$".extraConfig = ''
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          fastcgi_intercept_errors on;
          fastcgi_pass php-${cfg.appName};
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
          fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        '';
        "~* .(js|css|png|jpg|jpeg|gif|ico)$".extraConfig = ''
          expires max;
          log_not_found off;
        '';
        "~* /(wp-config.php|readme.html|license.txt)".extraConfig = ''
          deny all;
        '';
        "~* /(?:uploads|files|wp-content|wp-includes|akismet)/.*.php$".extraConfig =
          ''
            deny all;
          '';
        "~* ^.+.(bak|log|old|orig|original|php#|php~|php_bak|save|swo|swp|sql)$".extraConfig =
          ''
            deny all;
            access_log off;
            log_not_found off;
          '';
        "/favicon.ico".extraConfig = ''
          log_not_found off;
          access_log off;
        '';
        "/robots.txt".extraConfig = ''
          allow all;
          log_not_found off;
          access_log off;
        '';
      };
    };
  }) cfg.sites);

  config.services.phpfpm = lib.mkMerge (lib.mapAttrsToList (name: cfg: {
    pools.${cfg.appName} = {
      user = cfg.appName;
      settings = {
        "listen.owner" = config.services.nginx.user;
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 5;
        "php_admin_value[error_log]" = "stderr";
        "php_admin_flag[log_errors]" = true;
        "catch_workers_output" = true;
      };
      phpOptions = ''
        upload_max_filesize = ${builtins.toString cfg.max_upload_filesize}M
        post_max_size = ${builtins.toString cfg.max_upload_filesize}M
      '';
      phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
    };
  }) cfg.sites);

  config.services.mysql = lib.mkMerge (lib.mapAttrsToList (name: cfg: {
    enable = true;
    ensureDatabases = [ cfg.appName ];
    ensureUsers = [{
      name = cfg.appName;
      ensurePermissions = { "${cfg.appName}.*" = "ALL PRIVILEGES"; };
    }];
  }) cfg.sites);

  config.services.mysqlBackup = lib.mkMerge
    (lib.mapAttrsToList (name: cfg: { databases = [ cfg.appName ]; })
      cfg.sites);

  config.users = lib.mkMerge (lib.mapAttrsToList (name: cfg: {
    users.${cfg.appName} = {
      isSystemUser = true;
      # createHome = true; # Don't use this option! It will change the folder
      # permissions
      home = cfg.root;
      group = cfg.appName;
    };
    groups.${cfg.appName} = { };
  }) cfg.sites);

  config.environment.systemPackages = [ pkgs.wp-cli ];
}
