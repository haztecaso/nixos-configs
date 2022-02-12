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
      shells = {
        defaultShell = pkgs.bash; # TODO: Disable zsh for now, until I discover how to prolerly set EDITOR and VISUAL variables...
      };
      vim.package = "neovim";
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

