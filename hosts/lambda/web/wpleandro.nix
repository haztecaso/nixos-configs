{ config, lib, pkgs, ... }:
let
  root = "/var/www/wpleandro";
  app = "wpleandro";
  host = "delunesadomingo.es";
  host_old = "paseourbano.com";
in
{
  security.acme.certs."${host}" = {
    dnsProvider = "cloudflare";
    credentialsFile = config.age.secrets."cloudflare".path;
    group = "nginx";
    extraDomainNames = [ "*.${host}" ];
  };
  security.acme.certs."${host_old}" = {
    dnsProvider = "cloudflare";
    credentialsFile = config.age.secrets."cloudflare".path;
    group = "nginx";
    extraDomainNames = [ "*.${host}" ];
  };
  services = {
    nginx = {
      # additionalModules = [ pkgs.nginxModules.cache-purge ]; # TODO: Configurar cache
      upstreams."php-${app}" = {
        servers = {
          "unix:${config.services.phpfpm.pools.${app}.socket}" = { };
        };
      };
      virtualHosts = {
        "${host_old}" = {
          serverName = host_old;
          useACMEHost = host_old;
          addSSL = true;
          locations."/".return = "301 https://${host}$request_uri";
        };
        "*.${host}" = {
          serverName = "*.${host}";
          useACMEHost = host;
          addSSL = true;
          locations."/".return = "301 https://${host}$request_uri";
        };
        # TODO: abstract nginx config
        "${host}" = {
          useACMEHost = host;
          forceSSL = true;
          root = root;
          extraConfig = ''
            index index.php index.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=${app};
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
    };
    phpfpm.pools.${app} = {
      user = app;
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
      ensureDatabases = [ app ];
      ensureUsers = [
        {
          name = app;
          ensurePermissions = { "${app}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };
    mysqlBackup.databases = [ app ];
  };
  users.users.${app} = {
    isSystemUser = true;
    home = root;
    group = app;
  };
  users.groups.${app} = { };
  home-manager.sharedModules = [{
    custom.shortcuts.paths.wl = root;
  }];
}
