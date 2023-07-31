{ config, lib, pkgs, ... }:
{
  imports = [
    # ./lagransala.nix
    ./claudiogabis.nix
    ./colchonreview.nix
    ./drupaltest.nix
    ./elvivero.nix
    ./haztecaso.nix
    ./matomo.nix
    ./thumbor.nix
    ./vaultwarden.nix
    ./wpleandro.nix
    ./zulmarecchini.nix
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "adrianlattes@disroot.org";
  };

  age.secrets."cloudflare".file = ../../../secrets/cloudflare.age;

  networking.firewall.allowedTCPPorts = [ 80 443 ];

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
    mysqlBackup = {
      enable = true;
      calendar = "03:30:00";
      location = '/var/www/mysqlBackup';
      singleTransaction = true;
    };
    phpfpm.phpOptions = ''
      extension=${pkgs.phpExtensions.imagick}/lib/php/extensions/imagick.so
    '';
  };

  home-manager.sharedModules = [{
    custom.shortcuts.paths.w = "/var/www/";
  }];
}
