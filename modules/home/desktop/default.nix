{ config, lib, pkgs, ... }:
let
  cfg = config.custom.desktop;
in
{
  imports = [
      ./alacritty.nix
      ./polybar.nix
      ./keybindings.nix
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
        battery_level
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
      keyboard = {
        layout = "es";
        options = [ "caps:escape" ];
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
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };
      theme = {
        package = pkgs.arc-theme;
        name = "Arc-Dark";
      };
      # TODO: mix with shortcuts module
      gtk3.bookmarks = let home = config.home.homeDirectory; in [
        "file://${home}/Nube"
        "file://${home}/Documents"
        "file://${home}/Music"
        "file://${home}/Pictures"
        "file://${home}/Videos"
        "file://${home}/Downloads"
        "file://${home}/src"
      ];
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
        # extraConfig = { "ssh-client" = "mosh"; };
      };
    };
  };
}
