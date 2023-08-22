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
    ./meshcentral.nix
    ./thumbor.nix
    ./ulogger.nix
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
    borgbackup.jobs.webs = {
      paths = "/var/www/";
      exclude = [ "/var/www/haztecaso.com/radio-old/" ];
      encryption.mode = "none"; 
      environment.BORG_RSH = "ssh -i /home/skolem/.ssh/id_rsa";
      repo = "ssh://skolem@nas:22/mnt/raid/backups/borg/lambda-webs";
      compression = "auto,zstd";
      startAt = "3:30:0";
      persistentTimer = true;
      prune.keep = {
        within = "1d";
        daily = 7;
        weekly = 4;
        monthly = 6;
        yearly = 4;
      };
    };
    mysql.package = pkgs.mariadb;
    mysqlBackup = {
      enable = true;
      calendar = "03:00:00";
      location = "/var/www/mysqlBackup";
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
