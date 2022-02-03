{ config, lib, pkgs, ... }:
{
  imports = [
    ./haztecaso
    ./elvivero
    ./lagransala
    ./matomo
    ./thumbor
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
  };
}