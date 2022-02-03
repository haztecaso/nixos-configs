{ config, lib, pkgs, ... }:
let
  home-config = {
    home.packages = with pkgs; [
      # battery_level
      # bitwarden-rofi
      # dmenu_mpd
      # dmenu_run_history
      # message

      anki
      # audacity
      betterlockscreen
      bitwarden
      # blender
      # discord
      dmenu
      evince
      # filezilla
      firefox
      # gimp
      hsetroot
      # inkscape
      # kdenlive
      libreoffice
      light
      lxappearance
      # minecraft
      networkmanager-vpnc
      pamixer
      pavucontrol
      # scantailor-advanced
      scrot
      # soulseekqt
      sxiv
      tdesktop
      tor-browser-bundle-bin
      transmission-gtk
      vlc
      wmctrl
      xarchiver
      xfce.thunar
      xorg.xev
      xorg.xmodmap
    ];

    home.keyboard = {
      layout = "es";
      options = [
        "caps:escape"
        #"ctrl:nocaps"
      ];
    };
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad/xmonad.hs;
    };

  };
in
{
  options.custom.desktop = {
    enable = lib.mkEnableOption "Custom desktop environment (wm: xmonad)";
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

    home-manager.users.skolem = { ... }: home-config;

  };
}
