{ config, lib, pkgs, ... }: {
  options.custom.webserver.elvivero = {
    enable = lib.mkEnableOption "elvivero.es web server";
  };
  config = lib.mkIf config.custom.webserver.haztecaso.enable {
    security.acme.certs."elvivero.es" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets."cloudflare".path;
      group = "nginx";
    };
    services = {
      nginx.virtualHosts = {
        "elvivero.es" = {
          useACMEHost = "elvivero.es";
          forceSSL = true;
          root = "/var/www/elvivero.es";
          extraConfig = ''
            expires 1d;
            error_page 404 /404.html;
          '';
        };
        "www.elvivero.es" = {
          useACMEHost = "elvivero.es";
          forceSSL = true;
          locations."/".return = "301 https://elvivero.es$request_uri";
        };
      };
    };
    age.secrets."cloudflare".file = ../../../secrets/cloudflare.age;
  };
}
