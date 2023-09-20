{ config, lib, pkgs, ... }:
let
  root = "/var/www/elvivero.es";
  host = "elvivero.es";
in
{
  security.acme.certs."${host}" = {
    dnsProvider = "cloudflare";
    credentialsFile = config.age.secrets."cloudflare".path;
    group = "nginx";
    extraDomainNames = [ "*.${host}" ];
  };
  services = {
    nginx.virtualHosts = {
      "*.${host}" = {
        serverName = "*.${host}";
        useACMEHost = host;
        addSSL = true;
        locations."/".return = "301 https://${host}$request_uri";
      };
      "${host}" = {
        useACMEHost = host;
        forceSSL = true;
        root = root;
        extraConfig = ''
          expires 1d;
          error_page 404 /404.html;
          error_log syslog:server=unix:/dev/log debug;
          access_log syslog:server=unix:/dev/log,tag=elvivero;
        '';
      };
      "www.${host}" = {
        useACMEHost = host;
        forceSSL = true;
        locations."/".return = "301 https://elvivero.es$request_uri";
      };
      "cloud.elvivero.es" = {
        useACMEHost = host;
        forceSSL = true;
        locations."/".proxyPass = "http://nas:8888";
      };
    };
  };
  home-manager.sharedModules = [{
    custom.shortcuts.paths.we = root;
  }];
}
