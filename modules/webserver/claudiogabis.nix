{ config, lib, pkgs, ... }:
let
  root = "/var/www/claudiogabis.com";
in
{
  options.webserver.claudiogabis = {
    enable = lib.mkEnableOption "claudiogabis.com web server";
  };
  config = lib.mkIf config.webserver.claudiogabis.enable {
    security.acme.certs."claudiogabis.com" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets."cloudflare".path;
      group = "nginx";
      extraDomainNames = [ "*.claudiogabis.com" ];
    };
    services = {
      nginx.virtualHosts = {
        "*.claudiogabis.com" = {
          serverName = "*.claudiogabis.com";
          forceSSL = true;
          useACMEHost = "claudiogabis.com";
          locations."/".return = "404";
        };
        "claudiogabis.com" = {
          useACMEHost = "claudiogabis.com";
          forceSSL = true;
          root = root;
          extraConfig = ''
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=claudiogabis;
          '';
          locations."/".extraConfig = ''
            if ($request_uri ~ ^/(.*)index\.html) {
              return 302 /$1;
            }
            try_files $uri $uri.html $uri/ =404;
          '';
        };
        "www.claudiogabis.com" = {
          enableACME = true;
          locations."/".return = "301 https://claudiogabis.com$request_uri";
        };
      };
    };
    home-manager.sharedModules = [{
      custom.shortcuts.paths.wcg = root;
    }];
  };
}
