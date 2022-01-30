{ config, lib, pkgs, ... }: {
  options.custom.webserver.elvivero = {
    enable = lib.mkEnableOption "elvivero.es web server";
  };
  config = lib.mkIf config.custom.webserver.haztecaso.enable {
    services = {
      nginx.virtualHosts = {
        "elvivero.es" = {
          enableACME = true;
          forceSSL = true;
          root = "/var/www/elvivero.es";
          extraConfig = ''
            expires 1d;
            error_page 404 /404.html;
          '';
        };
        "www.elvivero.es" = {
          enableACME = true;
          forceSSL = true;
          locations."/".return = "301 https://elvivero.es$request_uri";
        };
      };
    };
  };
}
