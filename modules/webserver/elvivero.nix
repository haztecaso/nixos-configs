{ config, lib, pkgs, ... }:
let
  root = "/var/www/elvivero.es";
in
{
  options.webserver.elvivero = {
    enable = lib.mkEnableOption "elvivero.es web server";
  };
  config = lib.mkIf config.webserver.haztecaso.enable {
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
          # root = root;
          root = "${pkgs.elvivero-web}/www/";
          locations."/frutas/".extraConfig = ''
            alias ${pkgs.elvivero-frutas-web}/www/;
          '';
          extraConfig = ''
            expires 1d;
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=elvivero;
          '';
        };
        "www.elvivero.es" = {
          useACMEHost = "elvivero.es";
          forceSSL = true;
          locations."/".return = "301 https://elvivero.es$request_uri";
        };
      };
    };
    age.secrets."cloudflare".file = ../../secrets/cloudflare.age;
    shortcuts.paths.we = root;
  };
}
