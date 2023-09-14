{ config, lib, pkgs, ... }:
let
  host = "twozeroeightthree.com";
  root = "/var/www/${host}";
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
        useACMEHost = "${host}";
        forceSSL = true;
        # locations."/".return = "404";
        locations."/".return = "301 https://${host}$request_uri";
      };
      "${host}" = {
        useACMEHost = "${host}";
        forceSSL = true;
        root = root;
        extraConfig = ''
          error_log syslog:server=unix:/dev/log debug;
          access_log syslog:server=unix:/dev/log,tag=${host};
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
  home-manager.sharedModules = [{
    custom.shortcuts.paths.wz = root;
  }];
}
