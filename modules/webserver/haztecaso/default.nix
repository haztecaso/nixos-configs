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
          # root = inputs.www-haztecaso;
          root = "/var/www/haztecaso.com";
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
