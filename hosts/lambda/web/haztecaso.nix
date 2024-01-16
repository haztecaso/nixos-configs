{ config, lib, pkgs, ... }:
let
  root = "/var/www/haztecaso.com";
  redirectTo = destination: {
    useACMEHost = "haztecaso.com";
    forceSSL = true;
    locations."/".return = "301 https://${destination}$request_uri";
  };
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
          error_page 404 /404.html;
        '';

        # locations."/".extraConfig = ''
        #   if ($request_uri ~ ^/(.*)\.html) {
        #     return 302 /$1;
        #   }
        #   try_files $uri $uri.html $uri/ =404;
        # '';

        locations."/stream.mp3".proxyPass = "http://nas:8000/stream.mp3";
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
      # "devjxqhdknupcorelqxdbxo.haztecaso.com" = {
      #   useACMEHost = "haztecaso.com";
      #   forceSSL = true;
      #   root = "/var/www/devjxqhdknupcorelqxdbxo.haztecaso.com";
      # };
      "www.haztecaso.com" = {
        enableACME = true;
        locations."/".return = "301 https://haztecaso.com$request_uri";
      };
      "media.haztecaso.com" = redirectTo "media.bufanda.cc";
      "music.haztecaso.com" = redirectTo "music.bufanda.cc";
      "ombi.haztecaso.com" = redirectTo "ombi.bufanda.cc";
      "dl.haztecaso.com" = redirectTo "dl.bufanda.cc";
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
