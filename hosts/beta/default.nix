{ config, pkgs, ... }: let
  keys = import ../../ssh-keys.nix;
in
{
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 7d";


  programs = {
    vim.defaultEditor = true;
    bash = {
      promptInit = ''export PS1="\[\e[00;34m\][\u@β \w]\\$ \[\e[0m\]"'';
    };
  };


  home-manager.users.skolem = { ... }: {
    services.syncthing.enable = true;
  };

  custom = {
    base = {
      hostname = "beta";
      tmux.color = "#aaee00";
      wlp = { interface = "wlp3s0"; useDHCP = true; };
      eth.interface = "enp0s31f6";
    };

    desktop = {
      enable = true;
      bat = "BAT1";
      fontSize = 8;
    };

    dev.enable = true;

    # services.syncthing.enable = true; 

    stateVersion = "21.11";
  };

}

