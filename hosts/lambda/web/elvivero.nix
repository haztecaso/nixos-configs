{ config, lib, pkgs, ... }:
let
  root = "/var/www/elvivero.es";
  host = "elvivero.es";
  app = "wpelvivero";
in
{
  services = {
    nginx = {
      virtualHosts = {
        "*.${host}" = {
          serverName = "*.${host}";
          useACMEHost = host;
          addSSL = true;
          locations."/".return = "301 https://${host}$request_uri";
        };
        "old.${host}" = {
          useACMEHost = host;
          forceSSL = true;
          root = "${root}-old";
          extraConfig = ''
            expires 1d;
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=elviveroOld;
          '';
        };
        "static.${host}" = {
          useACMEHost = host;
          forceSSL = true;
          root = "${root}-static";
          extraConfig = ''
            expires 1d;
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=elviveroStatic;
          '';
        };
        "www.${host}" = {
          useACMEHost = host;
          forceSSL = true;
          locations."/".return = "301 https://elvivero.es$request_uri";
        };
      };
    };
  };
}
