{ config, lib, pkgs, ... }:
let
  name = "colchonreview";
  root = "/var/www/colchon.review";
in
{
  options.webserver.colchonreview = {
    enable = lib.mkEnableOption "colchon.review web server";
  };
  config = lib.mkIf config.webserver.colchonreview.enable {
    security.acme.certs."colchon.review" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets."cloudflare".path;
      group = "nginx";
    };
    services = {
      phpfpm.pools.${name} = {
        user = name;
        settings = {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = "root";
          "listen.mode" = "0660";
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 10;
          "pm.min_spare_servers" = 5;
          "pm.max_spare_servers" = 20;
          "pm.max_requests" = 500;
          "catch_workers_output" = true;
        };
        phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
      };
      nginx.virtualHosts = {
        "colchon.review" = {
          useACMEHost = "colchon.review";
          forceSSL = true;
          root = root;
          extraConfig = ''
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=colchonreview;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            index index.php index.html index.htm;
          '';
          locations = {
            "~ \.php".extraConfig = ''
              fastcgi_pass unix:${config.services.phpfpm.pools.${name}.socket};
              fastcgi_intercept_errors on;
              include ${pkgs.nginx}/conf/fastcgi_params;
              include ${pkgs.nginx}/conf/fastcgi.conf;
              fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
            '';
            "/".extraConfig = ''
              try_files $uri $uri/ /index.php?$args;
            '';
            "~ /\.".extraConfig = ''
                deny all;
            '';
            "~* /(?:uploads|files)/.*\.php$".extraConfig = ''
                deny all;
            '';
          };
        };
      };
      mysql = {
        enable = true;
        ensureDatabases = [ name ];
        ensureUsers = [{
          name = name;
          ensurePermissions = { "${name}.*" = "ALL PRIVILEGES"; };
        }];
      };
    };
    users.users.${name} = {
      isSystemUser = true;
      createHome = true;
      home = root;
      group = name;
    };
    users.groups.${name} = {};
    age.secrets."cloudflare".file = ../../secrets/cloudflare.age;
    home-manager.sharedModules = [{
      custom.shortcuts.paths.wc = root;
    }];
  };
}
