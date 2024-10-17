{ config, lib, pkgs, ... }:
#TODO: 
# automate some installation and config processes:
# - Create root folder if not exists and add install script that does the
# following (using wp-cli)
#   - helps setting mysql password
#   - downloads latest wordpress
#   - fills up wp-config.php
let
  cfg = config.services.custom.web.wordpress;
  siteOptions = { lib, config, ... }:
    let cfg = config;
    in {
      options = with lib; {
        appName = mkOption {
          type = types.str;
          example = "myweb";
          description =
            "Identifier used for naming php service (phpfpm) and database (mysql).";
          # TODO: assertions: appName should be only alpha characters
          # mirar type.strMatching
        };
        domain = mkOption {
          type = types.str;
          example = "myweb.com";
          description = "Website domain";
        };
        subdomain = mkOption {
          type = types.nullOr types.str;
          example = "wp";
          description =
            "Subdomain where to install wordpress. Main domain if null.";
        };
        host = mkOption {
          type = types.str;
          readOnly = true;
          description = "Concatenation of subdomain with domain.";
        };
        root = mkOption {
          type = types.str;
          description =
            "Wordpress root folder. Default /var/www/wordpress/<host>.";
        };
        ACMEHost = mkOption {
          type = types.str;
          description = "The ACME host to use for SSL.";
        };
        max_upload_filesize = mkOption {
          type = types.numbers.positive;
          default = 50;
          description = "The maximum upload file size in MB.";
        };
      };
      config = {
        subdomain = lib.mkDefault null;
        # TODO: use submodule attr name
        # appName = lib.mkDefault "wp${cfg.name}";
        root = lib.mkDefault "/var/www/wordpress/${cfg.host}";
        host = if cfg.subdomain == null then
          cfg.domain
        else
          "${cfg.subdomain}.${cfg.domain}";
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
        error_log syslog:server=unix:/dev/log debug;
        access_log syslog:server=unix:/dev/log,tag=${cfg.appName};
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
