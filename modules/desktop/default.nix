{ config, lib, pkgs, ... }:
let
  cfg = config.custom.desktop;
in
{
  options.custom.desktop = with lib; {
    enable = mkEnableOption "Enable system wide desktop support.";
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.mapAttrs
      (_: _: {
        extraGroups = [ "audio" "video" "networkmanager" ];
      })
      config.home-manager.users;
    services = {
      xserver = {
        enable = true;
        xkb = {
          layout = "es,us";
          options = "caps:escape,grp:alt_space_toggle";
        };
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          config = ./xmonad/xmonad.hs;
        };
        displayManager.sessionCommands = ''
          ${pkgs.xorg.xmodmap}/bin/xmodmap -e "keycode 135 = Super_L NoSymbol Super_L"
        '';
      };
      displayManager.autoLogin = {
        enable = true;
        user = lib.mkDefault "skolem";
      };
      blueman.enable = true;
      dbus = {
        enable = true;
        packages = [ pkgs.dconf ];
      };
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
      tumbler.enable = true;
    };
    base = {
      sound = true;
      printing = true;
    };
    programs = {
      light.enable = true;
      kdeconnect.enable = true;
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
      };
    };
    networking.networkmanager.enable = true;
    hardware = {
      bluetooth.enable = true;
      opengl.enable = true;
    };
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        dejavu_fonts
        noto-fonts
        noto-fonts-emoji
        font-awesome
        source-code-pro
        source-sans
        source-serif
        source-sans-pro
        source-serif-pro
        (nerdfonts.override { fonts = [ "Hack" "LiberationMono" ]; })
      ];
    };
    security = {
      pam.services.gdm.enableGnomeKeyring = true;
    };
  };
}
