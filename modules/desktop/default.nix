{ config, lib, pkgs, ... }:
let
  home-config = {
    imports = [
      ./alacritty.nix
      ./keybindings.nix
      ./notifications.nix
      ./web.nix
      ./zathura.nix
    ];
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
      options = [ "caps:escape" ];
    };

    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad/xmonad.hs;
    };

    xresources.extraConfig = builtins.readFile ./.Xresources;

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };
      theme = {
        package = pkgs.arc-theme;
        name ="Arc-Dark";
      };
      gtk3.bookmarks = [
        "file:///home/skolem/Sync"
        "file:///home/skolem/Documents"
        "file:///home/skolem/Documents/uni/Actuales Uni (Actuales)"
        "file:///home/skolem/Documents/desarrollo"
        "file:///home/skolem/Documents/desarrollo/webs"
        "file:///home/skolem/Music"
        "file:///home/skolem/Pictures"
        "file:///home/skolem/Videos"
        "file:///home/skolem/Downloads"
      ];
    };

    services = {
      polybar = {
        enable = true;
        config = ./polybar.ini;
        package = pkgs.polybarFull;
        script = "polybar bar &";
      };
    };

    programs = {
      rofi = {
        enable = true;
        font = "Hack Nerd Font 10";
        location = "center";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        pass.enable = true;
        theme = "gruvbox-dark-hard";
      };
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
        layout = "es";
        xkbOptions = "caps:escape";
        # displayManager.gdm.enable = true;
        # desktopManager.gnome.enable = true;
        # displayManager = {
        #   autoLogin.enable = true;
        #   autoLogin.user = "skolem";
        # };
        displayManager.lightdm.enable = true;
        desktopManager.xfce.enable = true;
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
      dbus = {
        enable = true;
        packages = [ pkgs.gnome3.dconf ];
      };
    };

    networking.networkmanager.enable = true;

    home-manager.users.skolem = { ... }: home-config;

  };
}
