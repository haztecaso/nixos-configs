{ config, pkgs, ... }: let
  keys = import ../../ssh-keys.nix;
in
{
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 3d";

  programs = {
    vim.defaultEditor = true;
  };

  custom = {
    base = {
      hostname = "nixpi";
      eth = { interface = "eth0"; useDHCP = true; };
    };

    programs = {
      tmux.color = "#aaee00";
    };

    stateVersion = "21.11";
  };

}

