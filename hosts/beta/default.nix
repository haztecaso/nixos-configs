{ config, pkgs, ... }: let
  keys = import ../../ssh-keys.nix;
in
{
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 7d";

  networking = {
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
  };

  programs = {
    vim.defaultEditor = true;
  };

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  custom = {
    base = {
      hostname = "beta";
      tmux.color = "#aaee00";
    };

    stateVersion = "21.11";
  };

}

