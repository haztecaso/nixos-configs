{ config, lib, pkgs, ... }:
let
  root = "/var/www/elvivero.es";
in
{
  security.acme.certs."elvivero.es" = {
    dnsProvider = "cloudflare";
    credentialsFile = config.age.secrets."cloudflare".path;
    group = "nginx";
  };
  services = {
    nginx.virtualHosts = {
      "elvivero.es" = {
        useACMEHost = "elvivero.es";
        forceSSL = true;
        root = root;
        extraConfig = ''
          expires 1d;
          error_page 404 /404.html;
          error_log syslog:server=unix:/dev/log debug;
          access_log syslog:server=unix:/dev/log,tag=elvivero;
        '';
      };
      "www.elvivero.es" = {
        useACMEHost = "elvivero.es";
        forceSSL = true;
        locations."/".return = "301 https://elvivero.es$request_uri";
      };
      "cloud.elvivero.es" = {
        useACMEHost = "elvivero.es";
        forceSSL = true;
        locations."/".proxyPass = "http://nas:8888";
      };
    };
  };
  home-manager.sharedModules = [{
    custom.shortcuts.paths.we = root;
  }];
}
