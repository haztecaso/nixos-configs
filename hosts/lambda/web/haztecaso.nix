{ config, lib, pkgs, ... }:
let
  root = "/var/www/haztecaso.com";
in
{
  security.acme.certs."haztecaso.com" = {
    dnsProvider = "cloudflare";
    credentialsFile = config.age.secrets."cloudflare".path;
    group = "nginx";
    extraDomainNames = [ "*.haztecaso.com" ];
  };
  services = {
    nginx.virtualHosts = {
      "*.haztecaso.com" = {
        serverName = "*.haztecaso.com";
        forceSSL = true;
        useACMEHost = "haztecaso.com";
        locations."/".return = "404";
      };
      "haztecaso.com" = {
        useACMEHost = "haztecaso.com";
        forceSSL = true;
        root = root;
        extraConfig = ''
          error_log syslog:server=unix:/dev/log debug;
          access_log syslog:server=unix:/dev/log,tag=haztecaso;
          add_header Access-Control-Allow-Origin "radio.haztecaso.com";
        '';

        # locations."/".extraConfig = ''
        #   if ($request_uri ~ ^/(.*)\.html) {
        #     return 302 /$1;
        #   }
        #   try_files $uri $uri.html $uri/ =404;
        # '';

        # locations."/stream.mp3".proxyPass = "http://nas:8000/stream.mp3";
        # locations."/mpdws" = {
        #   proxyPass = "http://localhost:8005";
        #   extraConfig = ''
        #     proxy_set_header Upgrade $http_upgrade;
        #     proxy_set_header Connection "upgrade";
        #   '';
        # };

        # Radio archive
        locations."/radio-old/archivo/".extraConfig = ''
          alias ${root}/radio-old/archivo/;
          autoindex on;
          add_before_body /autoindex/before-radio.txt;
          add_after_body /autoindex/after-radio.txt;
        '';
      };
      "devjxqhdknupcorelqxdbxo.haztecaso.com" = {
        useACMEHost = "haztecaso.com";
        forceSSL = true;
        root = "/var/www/devjxqhdknupcorelqxdbxo.haztecaso.com";
      };
      "www.haztecaso.com" = {
        enableACME = true;
        locations."/".return = "301 https://haztecaso.com$request_uri";
      };
      "media.haztecaso.com" = {
        useACMEHost = "haztecaso.com";
        forceSSL = true;
        locations."/".proxyPass = "http://nas:8096";
      };
      "music.haztecaso.com" = {
        useACMEHost = "haztecaso.com";
        forceSSL = true;
        locations."/".proxyPass = "http://nas:4747";
      };
    };
    # mpdws = {
    #   enable = true;
    #   port = 8005;
    #   host = "0.0.0.0";
    #   mpdHost = "nas";
    # };
  };
  home-manager.sharedModules = [{
    custom.shortcuts.paths.wh = root;
  }];
}
