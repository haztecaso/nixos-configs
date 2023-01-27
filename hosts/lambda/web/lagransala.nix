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
  home-manager.sharedModules = [{
    custom.shortcuts.paths.wl = root;
  }];
}
