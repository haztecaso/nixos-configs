{ config, lib, pkgs, ... }:
let
  root = "/var/www/zulmarecchini.com";
in
{
  options.webserver.zulmarecchini = {
    enable = lib.mkEnableOption "zulmarecchini.com web server";
  };
  config = lib.mkIf config.webserver.zulmarecchini.enable {
    security.acme.certs."zulmarecchini.com" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets."cloudflare".path;
      group = "nginx";
      extraDomainNames = [ "*.zulmarecchini.com" ];
    };
    services = {
      nginx.virtualHosts = {
        "*.zulmarecchini.com" = {
          serverName = "*.zulmarecchini.com";
          forceSSL = true;
          useACMEHost = "zulmarecchini.com";
          locations."/".return = "404";
        };
        "zulmarecchini.com" = {
          useACMEHost = "zulmarecchini.com";
          forceSSL = true;
          root = root;
          extraConfig = ''
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=zulmarecchini;
          '';
          locations."/".extraConfig = ''
            if ($request_uri ~ ^/(.*)index\.html) {
              return 302 /$1;
            }
            try_files $uri $uri.html $uri/ =404;
          '';
        };
        "www.zulmarecchini.com" = {
          enableACME = true;
          locations."/".return = "301 https://zulmarecchini.com$request_uri";
        };
      };
    };
    home-manager.sharedModules = [{
      custom.shortcuts.paths.wz = root;
    }];
  };
}
