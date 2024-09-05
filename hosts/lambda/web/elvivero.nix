{ config, lib, pkgs, ... }:
let
  redirectTo = destination: {
    useACMEHost = "haztecaso.com";
    forceSSL = true;
    locations."/".return = "301 https://${destination}$request_uri";
  };
in
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
        "www.elvivero.es" = redirectTo "elvivero.es";
        "equisoain.elvivero.es" = redirectTo "equisoain.com";
      };
    };
  };
}
