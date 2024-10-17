{ config, lib, pkgs, ... }:
let cfg = config.custom.desktop;
in {
  imports = [
    ./alacritty.nix
    ./polybar
    ./keybindings.nix
    ./mpv.nix
    ./notifications.nix
    ./web.nix
    ./zathura.nix
  ];
  options.custom.desktop = with lib; {
    enable = mkEnableOption "Wether to enable desktop configs for user.";
    fontSize = mkOption {
      type = types.int;
      default = 10;
      description = "Base desktop font size";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        arandr
        battery_level
        betterlockscreen
        blueman
        dmenu
        hsetroot
        light
        lxappearance
        networkmanager-vpnc
        pamixer
        scrot
        pavucontrol
        xfce.thunar
        wmctrl
        xarchiver
        xorg.xev
        xorg.xmodmap
      ];
      keyboard = {
        layout = "es,us";
        options = [ "caps:escape" "grp:alt_space_toggle" ];
      };
    };
    xsession = {
      enable = true;
      initExtra = ''
        ${pkgs.batsignal}/bin/batsignal -b -w 14 -c 6 -d 3
      '';
    };

    xresources.extraConfig = builtins.readFile ./.Xresources;

    gtk = {
      enable = true;
      # TODO: mix with shortcuts module
      gtk3.bookmarks = let home = config.home.homeDirectory;
      in [
        "file://${home}/Nextcloud"
        "file://${home}/Documents"
        "file://${home}/Music"
        "file://${home}/Pictures"
        "file://${home}/Videos"
        "file://${home}/Downloads"
        "file://${home}/src"
      ];
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };
      theme = {
        package = pkgs.arc-theme;
        name = "Arc-Dark";
      };
    };

    services = {
      network-manager-applet.enable = true;
      pasystray.enable = true;
      blueman-applet.enable = true;

      flameshot = {
        enable = true;
        settings.General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
        };
      };

      screen-locker = {
        enable = false; # TODO
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
        tray = true;
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
        package =
          pkgs.rofi.override { plugins = [ pkgs.rofi-rbw pkgs.rofi-calc ]; };
        font = "Hack Nerd Font 10";
        location = "center";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        pass.enable = true;
        theme = "gruvbox-dark-hard";
        extraConfig = {
          modi = "run,ssh,window,drun,calc";
          dpi = 180;
          # "ssh-client" = "mosh"; 
        };
      };
      autorandr = {
        enable = true;
        hooks.postswitch = {
          "polybar-restart" = "systemctl --user restart polybar";
          "hsetroot" = "${pkgs.hsetroot}/bin/hsetroot";
        };
      };
    };
  };
}
