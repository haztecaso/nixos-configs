{ config, lib, pkgs, ... }: {
  options.custom.webserver.haztecaso = {
    enable = lib.mkEnableOption "haztecaso.com web server";
  };
  config = lib.mkIf config.custom.webserver.haztecaso.enable {
    services = {
      nginx.virtualHosts = {
        "haztecaso.com" = {
          enableACME = true;
          forceSSL = true;
          root = "/var/www/haztecaso.com";

          # Radio archive
          locations."/radio/archivo".extraConfig = ''
            alias /var/www/haztecaso.com/radio/archivo;
            autoindex on;
            add_before_body /autoindex/before-radio.txt;
            add_after_body /autoindex/after-radio.txt;
          '';
        };
        "www.haztecaso.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/".return = "301 https://haztecaso.com$request_uri";
        };
      };
    };
  };
}
