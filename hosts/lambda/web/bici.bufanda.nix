{ config, lib, pkgs, ... }:
let
  app = "bicibufanda";
  root = "/var/www/bici.bufanda.cc";
  max_upload_filesize = "100M";
in
{
  services = {
    nginx = {
      upstreams."php-wpbici" = {
        servers = {
          "unix:${config.services.phpfpm.pools.${app}.socket}" = { };
        };
      };
      virtualHosts = {
        # TODO: abstract nginx config
        "bici.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          inherit root;
          extraConfig = ''
            index index.php index.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=wpbici;
            client_max_body_size ${max_upload_filesize};
          '';
          locations = {
            "/".extraConfig = ''
              try_files $uri $uri/ /index.php?$args;
            '';
            "~ \.php$".extraConfig = ''
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_intercept_errors on;
              fastcgi_pass php-wpbici;
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
        "tools.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          root = "/var/www/tools.bufanda.cc/";
          extraConfig = ''
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=toolsbufanda;
            try_files $uri $uri.html $uri/ =404;
          '';
        };
        "mapa.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          root = "/var/www/mapa.bufanda.cc/";
          extraConfig = ''
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=mapabufanda;
            try_files $uri $uri.html $uri/ =404;
          '';
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
    custom.shortcuts.paths.wbb = root;
  }];
}
