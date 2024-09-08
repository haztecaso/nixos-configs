{ config, lib, pkgs, ... }:
{
  services = {
    nginx = {
      virtualHosts = {
        "old.elvivero.es" = {
          useACMEHost = "elvivero.es";
          forceSSL = true;
          root = "/var/www/elvivero.es-old";
          extraConfig = ''
            expires 1d;
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=elviveroOld;
          '';
        };
        "static.elvivero.es" = {
          useACMEHost = "elvivero.es";
          forceSSL = true;
          root = "/var/www/elvivero.es-static";
          extraConfig = ''
            expires 1d;
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=elviveroStatic;
          '';
        };
      };
    };
  };
}
