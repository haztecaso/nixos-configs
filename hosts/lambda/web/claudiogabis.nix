{ config, lib, pkgs, ... }:
let
  root = "/var/www/claudiogabis.com";
  app = "wpclau";
  max_upload_filesize = "400M";
in
{
  services = {
    nginx = {
      upstreams."php-wpclau" = {
        servers = {
          "unix:${config.services.phpfpm.pools.${app}.socket}" = { };
        };
      };
      virtualHosts = {
        "*.claudiogabis.com" = {
          serverName = "*.claudiogabis.com";
          forceSSL = true;
          useACMEHost = "claudiogabis.com";
          locations."/".return = "404";
        };
        # TODO: abstract nginx config
        "claudiogabis.com" = {
          useACMEHost = "claudiogabis.com";
          forceSSL = true;
          root = root;
          extraConfig = ''
            index index.php index.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=claudiogabis;
            client_max_body_size ${max_upload_filesize};
          '';
          locations = {
            "/".extraConfig = ''
              try_files $uri $uri/ /index.php?$args;
            '';
            "~ \.php$".extraConfig = ''
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_intercept_errors on;
              fastcgi_pass php-wpclau;
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
        "www.claudiogabis.com" = {
          enableACME = true;
          locations."/".return = "301 https://claudiogabis.com$request_uri";
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
        upload_max_filesize = ${max_upload_filesize}
        post_max_size = ${max_upload_filesize}
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
    # createHome = true;
    home = root;
    group = app;
  };
  users.groups.${app} = { };
  home-manager.sharedModules = [{
    custom.shortcuts.paths.wcg = root;
  }];
}
