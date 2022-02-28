{ config, pkgs, ... }: let
  keys = import ../../ssh-keys.nix;
in
{
  imports = [ ./hardware.nix ./monitors.nix ];

  nix.gc.options = "--delete-older-than 7d";

  home-manager.users.skolem = { ... }: {
    services.syncthing.enable = true;
  };

  custom = {
    base = {
      hostname = "beta";
      hostnameSymbol = "β"; 
      wlp = { interface = "wlp3s0"; useDHCP = true; };
      eth.interface = "enp0s31f6";
    };

    programs = {
      tmux.color = "#aaee00";
      vim.package = "neovim";
      latex.enable = true;
    };

    shortcuts.paths = {
      D  = "~/Downloads";
      cf = "~/.config";
      d  = "~/Documents";
      l  = "~/Nube/lecturas";
      mm = "~/Music";
      mo = "~/Nube/money";
      n  = "/etc/nixos";
      pp = "~/Pictures";
      sr = "~/src";
      u  = "~/Nube/uni/Actuales";
      vv = "~/Videos";
    };

    desktop = {
      enable = true;
      bat = "BAT1";
      fontSize = 8;
    };

    dev.enable = true;

    stateVersion = "21.11";
  };
}

