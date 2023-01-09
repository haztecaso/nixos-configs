{ config, lib, pkgs, ... }:
let
  root = "/var/www/wpleandro";
  app  = "wpleandro";
in
{
  options.webserver.wpleandro = {
    enable = lib.mkEnableOption "Leandro wp";
  };
  config = lib.mkIf config.webserver.wpleandro.enable {
    services = {
      nginx = {
        upstreams."php-${app}" = {
          servers = {
            "unix:${config.services.phpfpm.pools.${app}.socket}" =  {};
          };
        };
        virtualHosts = {
          "wpleandro.elvivero.es" = {
            useACMEHost = "elvivero.es";
            forceSSL = true;
            root = root;
            extraConfig = ''
              index index.php index.html;
              error_log syslog:server=unix:/dev/log debug;
              access_log syslog:server=unix:/dev/log,tag=${app};
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
        phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
      };
    };
    users.users.${app} = {
      isSystemUser = true;
      home = root;
      group  = app;
    };
    users.groups.${app} = {};
    home-manager.sharedModules = [{
      custom.shortcuts.paths.wl = root;
    }];
  };
}
