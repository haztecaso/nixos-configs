{ config, lib, pkgs, ... }:
let
  root = "/var/www/drupaltest";
  app  = "drupaltest";
in
{
  services = {
    nginx = {
      upstreams."php-${app}" = {
        servers = {
          "unix:${config.services.phpfpm.pools.${app}.socket}" =  {};
        };
      };
      virtualHosts = {
        "drupaltest.haztecaso.com" = {
          useACMEHost = "haztecaso.com";
          forceSSL = true;
          root = root;
          extraConfig = ''
            index index.php index.html;
            error_log /var/log/nginx/drupaltest-error.log warn;
            access_log /var/log/nginx/drupaltest-access.log;
            client_max_body_size 20M;
            if ($request_uri ~* "^(.*/)index\.php/(.*)") {
                return 307 $1$2;
            }
          '';
          locations = {
            "/".extraConfig = ''
              try_files $uri /index.php?$query_string;
            '';
            "@rewrite".extraConfig = ''
              rewrite ^ /index.php;
            '';
            "~ '\.php$|^/update.php'".extraConfig = ''
              fastcgi_split_path_info ^(.+?\.php)(|/.*)$;
              try_files $fastcgi_script_name =404;
              fastcgi_pass php-${app};
              include ${pkgs.nginx}/conf/fastcgi_params;
              include ${pkgs.nginx}/conf/fastcgi.conf;
              fastcgi_param HTTP_PROXY "";
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param PATH_INFO $fastcgi_path_info;
              fastcgi_param QUERY_STRING $query_string;
              fastcgi_intercept_errors on;
            '';
            "~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$".extraConfig = ''
              try_files $uri @rewrite;
              expires max;
              log_not_found off;
            '';
            "~ ^/sites/.*/files/styles/".extraConfig = ''
              try_files $uri @rewrite;
            '';
            "~ /vendor/.*\.php$".extraConfig = ''
              deny all;
              return 404;
            '';
            "~* \.(engine|inc|install|make|module|profile|po|sh|.*sql|theme|twig|tpl(\.php)?|xtmpl|yml)(~|\.sw[op]|\.bak|\.orig|\.save)?$|^(\.(?!well-known).*|Entries.*|Repository|Root|Tag|Template|composer\.(json|lock)|web\.config)$|^#.*#$|\.php(~|\.sw[op]|\.bak|\.orig|\.save)$".extraConfig = ''
              deny all;
              return 404;
            '';
            "~ ^/sites/.*/private/".extraConfig = ''
              return 403;
            '';
            "~ ^/sites/[^/]+/files/.*\.php$".extraConfig = ''
              deny all;
            '';
            "/favicon.ico".extraConfig = ''
              log_not_found off;
              access_log off;
            '';
            "/robots.txt".extraConfig = ''
              try_files $uri $uri/ /index.php?$args;
            '';
            "~ \.(txt|log)$".extraConfig = ''
              deny all;
            '';
            "~ \..*/.*\.php$".extraConfig = ''
              return 403;
            '';
            "~ (^|/)\.".extraConfig = ''
              return 403;
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
  };
  users.users.${app} = {
    isSystemUser = true;
    home = root;
    group  = app;
  };
  users.groups.${app} = {};
  home-manager.sharedModules = [{
    custom.shortcuts.paths.wdt = root;
  }];
}
