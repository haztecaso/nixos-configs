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

  options.custom.webserver = {
    enable = lib.mkEnableOption "web server";
  };

  config = lib.mkIf config.custom.webserver.enable {
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

    custom.shortcuts.paths = {
        w  = "/var/www/";
    };
  };
}
