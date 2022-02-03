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
    bash = {
      promptInit = ''export PS1="\[\e[00;34m\][\u@β \w]\\$ \[\e[0m\]"'';
    };
  };

  custom = {
    base = {
      hostname = "beta";
      tmux.color = "#aaee00";
    };

    desktop = {
      enable = true;
    };

    stateVersion = "21.11";
  };

}

