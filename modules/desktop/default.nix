{ config, lib, pkgs, ... }:
{
  options.custom.desktop = {
    enable = lib.mkEnable "Custom desktop environment (wm: xmonad)";
  };

  config = {

    services = {
      xserver = {
        enable = true;
        xkbOptions = "caps:escape";
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };
    };

  };
}
