{ config, lib, pkgs, ... }:
{
  services = {
    nginx.virtualHosts = {
      "twozeroeightthree.com" = {
        useACMEHost = "twozeroeightthree.com";
        forceSSL = true;
        root = "/var/www/twozeroeightthree.com";
        extraConfig = ''
          error_log syslog:server=unix:/dev/log debug;
          access_log syslog:server=unix:/dev/log,tag=twozeroeightthree;
        '';
        locations."/".extraConfig = ''
          if ($request_uri ~ ^/(.*)index\.html) {
            return 302 /$1;
          }
          try_files $uri $uri.html $uri/ =404;
        '';
      };
    };
  };
}
