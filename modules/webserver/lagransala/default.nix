{ config, lib, pkgs, ... }:
let
  redirectConfig = {
    enableACME = true;
    forceSSL = true;
    locations."/".return = "301 https://lagransala.es$request_uri";
  };
in
{
  options.custom.webserver.lagransala = {
    enable = lib.mkEnableOption "lagransala.es web server";
  };
  config = lib.mkIf config.custom.webserver.lagransala.enable {
    services = {
      nginx.virtualHosts = {
        "lagransala.es" = {
          enableACME = true;
          forceSSL = true;
          # root = inputs.www-lagransala;
          root = "/var/www/lagransala.es";
          extraConfig = ''
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=lagransala;
          '';
        };
        "lagransala.org" = redirectConfig;
        "lagransala.com" = redirectConfig;
      };
    };
  };
}
