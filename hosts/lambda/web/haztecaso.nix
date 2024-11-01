{ config, lib, pkgs, ... }:
let
  root = "/var/www/haztecaso.com";
in
{
  services = {
    nginx.virtualHosts."haztecaso.com" = {
      useACMEHost = "haztecaso.com";
      forceSSL = true;
      root = root;
      extraConfig = ''
        error_log /var/log/nginx/haztecaso-error.log warn;
        access_log /var/log/nginx/haztecaso-access.log;
        add_header Access-Control-Allow-Origin "radio.haztecaso.com";
        error_page 404 /404.html;
      '';

      locations."/stream.mp3".proxyPass = "http://nas:8000/stream.mp3";

      # Radio archive
      locations."/radio-old/archivo/".extraConfig = ''
        alias ${root}/radio-old/archivo/;
        autoindex on;
        add_before_body /autoindex/before-radio.txt;
        add_after_body /autoindex/after-radio.txt;
      '';

      # locations."/".extraConfig = ''
      #   if ($request_uri ~ ^/(.*)\.html) {
      #     return 302 /$1;
      #   }
      #   try_files $uri $uri.html $uri/ =404;
      # '';

      # locations."/mpdws" = {
      #   proxyPass = "http://localhost:8005";
      #   extraConfig = ''
      #     proxy_set_header Upgrade $http_upgrade;
      #     proxy_set_header Connection "upgrade";
      #   '';
      # };
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
