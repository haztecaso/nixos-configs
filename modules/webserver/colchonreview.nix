{ config, lib, pkgs, ... }:
let
  root = "/var/www/colchon.review";
in
{
  options.webserver.colchonreview = {
    enable = lib.mkEnableOption "colchon.review web server";
  };
  config = lib.mkIf config.webserver.colchonreview.enable {
    # security.acme.certs."colchon.review" = {
    #   dnsProvider = "cloudflare";
    #   credentialsFile = config.age.secrets."cloudflare".path;
    #   group = "nginx";
    # };
    services = {
      wordpress."colchon.review" = { };
    };
    # age.secrets."cloudflare".file = ../../secrets/cloudflare.age;
    shortcuts.paths.wc = root;
  };
}
