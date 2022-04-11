{ config, lib, pkgs, ... }:
let
  root = "/var/www/haztecaso.com";
in
{
  options.webserver.haztecaso = {
    enable = lib.mkEnableOption "haztecaso.com web server";
  };
  config = lib.mkIf config.webserver.haztecaso.enable {
    services = {
      nginx.virtualHosts = {
        "haztecaso.com" = {
          enableACME = true;
          forceSSL = true;
          root = root;
          extraConfig = ''
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=haztecaso;
          '';

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
    custom.shortcuts.paths = {
        wh = root;
    };
  };
}
