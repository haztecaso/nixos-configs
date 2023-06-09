{ config, pkgs, inputs, ... }:
{
  imports = [ ./hardware.nix ./monitors.nix ];

  nix.gc.options = "--delete-older-than 18d";

  users.users.skolem = {
    openssh.authorizedKeys.keys = with config.base.ssh-keys; [ skolem termux ];
    extraGroups = [ "docker" "adbusers" ];
  };

  home-manager.users = {
    root = { ... }: {
      custom.programs = {
        tmux.color = "#eeaa00";
      };
    };
    skolem = { ... }: {
      home.packages = with pkgs; [ autofirma thunderbird timewarrior ];
      services.syncthing.enable = true;
      custom = {
        desktop = {
          enable = true;
          fontSize = 9;
        };
        programs = {
          latex.enable = true;
          tmux.color = "#aaee00";
          vim.package = pkgs.neovimDefault;
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    sqlitebrowser
    redis
    zotero
    obsidian
    qgis
  ];

  virtualisation = {
    docker.enable = true;
  };

  base = {
    hostname = "elbrus";
    hostnameSymbol = "ε";
    bat = "BAT1";
    wlp = { interface = "wlp4s0"; useDHCP = true; };
    eth.interface = "enp0s31f6";
    stateVersion = "23.05";
  };


  programs = {
    mosh.enable = true;
    dconf.enable = true;
  };

  services = {
    # safeeyes.enable = true;
    printing.drivers = [
      (pkgs.writeTextDir "share/cups/model/ricoh-mp-c2011-pdf.ppd" (builtins.readFile ./Ricoh-MP_C2011-PDF-Ricoh.ppd))
    ];
  };

  custom = {
    desktop.enable = true;

    services = {
      tailscale.enable = true;
      autofs.enable = true;
    };

    dev = {
      enable = true;
      nodejs = true;
      direnv.enable = true;
    };
  };
  fonts.fonts = [ pkgs.google-fonts ];
  networking.firewall = {
    allowedTCPPorts = [ 80 ];
  };


}
