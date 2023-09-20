{ config, lib, pkgs, ... }:
let
  cfg = config.services.custom.web.wordpress;
  siteOptions = { config, lib, pkgs, ... } : {
    options = with lib; {
      appName = mkOption {
        type = types.str;
        example = "myweb";
        description = "Identifier used for naming services and databases.";
      };
      domain = mkOption {
        type = types.str;
        example = "myweb.com";
        description = "Website domain";
      };
      subdomain = mkOption {
        type = types.nullOr types.str;
        example = "wp";
        description = "Subdomain where to install wordpress. Main domain if null.";
      };
      host = mkOption {
        type = types.str;
        readOnly = true;
        description = "Concatenation of subdomain with domain.";
      };
      root = mkOption {
        type = types.str;
        example = "/var/www/myweb.com";
        description = "Wordpress root folder.";
      };
      ACMEHost = mkOption {
        type = types.str;
        readOnly = true;
        description = "The ACME host to use for SSL.";
      };
    };
  };
  mkSiteConfig = name: config: 
  let 
    siteCfg = cfg.sites.${name};
  in
  with siteCfg; {
    siteCfg = {
      appName = lib.mkDefault "wp${name}";
      host = if subdomain == null then domain else "${subdomain}.${domain}";
      root = lib.mkDefault "/var/www/${appName}";
      ACMEHost = lib.mkDefault domain;
    };
    services = {
      nginx = {
        upstreams."php-${appName}".servers."unix:${config.services.phpfpm.pools.${app}.socket}" =  {};
        virtualHosts = {
          "${host}" = {
            inherit root;
            useACMEHost = ACMEHost;
            forceSSL = true;
            extraConfig = ''
              index index.php index.html;
              error_log syslog:server=unix:/dev/log debug;
              access_log syslog:server=unix:/dev/log,tag=${appName};
              client_max_body_size 20M;
            '';
            locations = {
              "/".extraConfig = ''
                try_files $uri $uri/ /index.php?$args;
              '';
              "~ \.php$".extraConfig = ''
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_intercept_errors on;
                fastcgi_pass php-${app};
                include ${pkgs.nginx}/conf/fastcgi_params;
                include ${pkgs.nginx}/conf/fastcgi.conf;
                fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
              '';
              "~* \.(js|css|png|jpg|jpeg|gif|ico)$".extraConfig = ''
                expires max;
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
        };
        phpfpm.pools.${appName} = {
          user = appName;
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
            upload_max_filesize = 20M
            post_max_size = 25M
          '';
          phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
        };
        mysql = {
          enable = true;
          ensureDatabases = [ appName ];
          ensureUsers = [
            {
              name = appName;
              ensurePermissions = { "${appName}.*" = "ALL PRIVILEGES"; };
            }
          ];
        };
        mysqlBackup.databases = [ appName ];
      };
    };
    users.users.${appName} = {
      isSystemUser = true;
      home = root;
      group  = appName;
    };
    users.groups.${appName} = {};
  };
in
{
  options = {
    services.custom.web.wordpress = with lib; {
      sites = mkOption {
        type = types.attrsOf (types.submodule siteOptions);
        default = {};
        description = "Wordpress sites configurations";
      };
    };
    config = lib.mkMerge (lib.mapAttrsToList mkSiteConfig cfg.sites);
  };
}
