{ config, pkgs, ... }: let
  keys = import ../../ssh-keys.nix;
in
{
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 3d";

  networking = {
    interfaces.eth0.useDHCP = true;
  };

  programs = {
    vim.defaultEditor = true;
  };

  custom = {
    base = {
      hostname = "nixpi";
      tmux.color = "#ee00aa";
    };
    services = {
      jobo_bot.enable = true;
    };
    stateVersion = "21.11";
  };

}

