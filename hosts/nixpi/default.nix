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
    base.hostname = "nixpi";

    programs = {
      tmux.color = "#aaee00";
      shells.defaultShell = pkgs.bash; # TODO: Disable zsh for now, until I discover how to prolerly set EDITOR and VISUAL variables...
    };

    stateVersion = "21.11";
  };

}

