{ config, lib, pkgs, ... }:
let
  root = "/var/www/haztecaso.com";
in
{
  options.webserver.haztecaso = {
    enable = lib.mkEnableOption "haztecaso.com web server";
  };
  config = lib.mkIf config.webserver.haztecaso.enable {
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

          locations."/stream".proxyPass = "http://raspi-music:8000";

          # Radio archive
          locations."/radio/archivo/".extraConfig = ''
            alias ${root}/radio/archivo/;
            autoindex on;
            add_before_body /autoindex/before-radio.txt;
            add_after_body /autoindex/after-radio.txt;
          '';
        };
        "www.haztecaso.com" = {
          enableACME = true;
          locations."/".return = "301 https://haztecaso.com$request_uri";
        };
      };
    };
    shortcuts.paths.wh = root;
  };
}
