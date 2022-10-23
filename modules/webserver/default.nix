{ config, lib, pkgs, ... }:
{
  imports = [
    ./claudiogabis.nix
    ./colchonreview.nix
    ./elvivero.nix
    ./haztecaso.nix
    ./lagransala.nix
    ./matomo.nix
    ./thumbor.nix
    ./zulmarecchini.nix
  ];

  options.webserver = with lib; {
    enable = mkEnableOption "web server";
  };

  config = lib.mkIf config.webserver.enable {
    security = {
      acme = {
        acceptTerms = true;
        defaults.email = "adrianlattes@disroot.org";
      };
    };

    networking = {
      firewall = {
        allowedTCPPorts = [ 80 443 ];
      };
    };

    services = {
      nginx = {
        enable = true;
        enableReload = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };
      mysql.package = pkgs.mariadb;
      phpfpm.phpOptions = ''
        extension=${pkgs.phpExtensions.imagick}/lib/php/extensions/imagick.so
      '';
    };

    home-manager.sharedModules = [{
      custom.shortcuts.paths.w = "/var/www/";
    }];
  };
}
