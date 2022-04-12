{ config, lib, pkgs, ... }:
{
  imports = [
    ./code.nix
    ./elvivero.nix
    ./haztecaso.nix
    ./lagransala.nix
    ./matomo.nix
    ./thumbor.nix
  ];

  options.webserver = {
    enable = lib.mkEnableOption "web server";
  };

  config = lib.mkIf config.webserver.enable {
    security = {
      acme = {
        acceptTerms = true;
        email = "adrianlattes@disroot.org";
      };
    };

    networking = {
      firewall = {
        allowedTCPPorts = [ 80 443 ];
      };
    };

    services.nginx = {
      enable = true;
      enableReload = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };

    shortcuts.paths = {
        w  = "/var/www/";
    };
  };
}
