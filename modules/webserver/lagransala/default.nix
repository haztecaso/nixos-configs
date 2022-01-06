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
  config = lib.mkIf options.custom.webserver.lagransala.enable {
    services = {
      nginx.virtualHosts = {
        "lagransala.es" = {
          enableACME = true;
          forceSSL = true;
          # root = inputs.www-lagransala;
          root = "/var/www/lagransala.es";
        };
        "lagransala.org" = redirectConfig;
        "lagransala.com" = redirectConfig;
      };
    };
  };
}
