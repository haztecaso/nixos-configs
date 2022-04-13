{ config, lib, pkgs, ... }:
let
  home-config = {
    imports = [
      ./keybindings.nix
      ./notifications.nix
      ./web.nix
      ./zathura.nix
      ./mpv.nix
    ];
    home.packages = with pkgs; [
      battery_level
      bitwarden-rofi

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
      gimp
      hsetroot
      inkscape
      # kdenlive
      libreoffice
      light
      lxappearance
      # minecraft
      networkmanager-vpnc
      pamixer
      pavucontrol
      blueman
      # scantailor-advanced
      scrot
      # soulseekqt
      sxiv
      unstable.tdesktop
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

    xsession = {
      enable = true;
      initExtra = ''
        ${pkgs.batsignal}/bin/batsignal -b -w 14 -c 6 -d 3
      '';
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = ./xmonad/xmonad.hs;
      };
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

    security = {
      pam.services.gdm.enableGnomeKeyring = true;
    };

    services = {
      network-manager-applet.enable = true;
      pasystray.enable = true;
      blueman-applet.enable = true;
      gnome.gnome-keyring.enable = true;
      printing.enable = true;
      printing.drivers = [ pkgs.hplip ];

      flameshot = {
        enable = true;
        settings.General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
        };
      };

      screen-locker = {
        enable = false; #TODO
        inactiveInterval = 30;
        lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
      };

      kdeconnect = {
        enable = true;
        indicator = true;
      };

      udiskie = {
        enable = true;
        automount = false;
        tray = "always";
      };

      redshift = {
        enable = true;
        latitude = "40.5249726";
        longitude = "-4.3764132";
        temperature = {
          day = 5500;
          night = 3200;
        };
      };

      picom.enable = true;
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
  options.desktop = with lib; {
    enable = mkEnableOption "Custom desktop environment (wm: xmonad)";
    bat = mkOption {
      type = types.str;
      default = "BAT0";
      description = "Battery device name";
    };
    fontSize = mkOption {
      type = types.int;
      default = 10;
      description = "Base desktop font size";
    };
  };

 imports = [
    ./alacritty.nix
    ./polybar.nix
    ./monitors.nix
 ];

  config = lib.mkIf config.desktop.enable {
    services = {
      xserver = {
        enable = true;
        layout = "es";
        xkbOptions = "caps:escape";
        displayManager = {
          lightdm.enable = true;
          autoLogin.enable = true;
          autoLogin.user = "skolem";
        };
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

    sound.enable = true; # Enable sound.

    hardware = {
      pulseaudio {
        enable = true;
        extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1"; # Needed by mpd to be able to use Pulseaudio
      };
      bluetooth.enable  = true;
      opengl.enable     = true;
    };

    programs = {
      light.enable = true;
      # adb.enable = true;
    };

    users.users.skolem = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    };

    nixpkgs.config.allowUnfree = true; # Necessary for some nonfree programs included by this module

    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
        google-fonts
        dejavu_fonts
        noto-fonts
        noto-fonts-emoji
        font-awesome
        (nerdfonts.override { fonts = [ "Hack" "LiberationMono" ]; })
      ];
    };

    networking.networkmanager.enable = true;

    home-manager.users.skolem = { ... }: home-config;

  };
}
