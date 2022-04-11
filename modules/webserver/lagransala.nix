{ config, lib, pkgs, ... }:
let
  redirectConfig = {
    enableACME = true;
    forceSSL = true;
    locations."/".return = "301 https://lagransala.es$request_uri";
  };
  root = "/var/www/lagransala.es";
in
{
  options.webserver.lagransala = {
    enable = lib.mkEnableOption "lagransala.es web server";
  };
  config = lib.mkIf config.webserver.lagransala.enable {
    services = {
      nginx.virtualHosts = {
        "lagransala.es" = {
          enableACME = true;
          forceSSL = true;
          # root = inputs.www-lagransala;
          root = root;
          extraConfig = ''
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=lagransala;
          '';
        };
        "lagransala.org" = redirectConfig;
        "lagransala.com" = redirectConfig;
      };
    };
    shortcuts.paths = {
        wl = root;
    };
  };
}
