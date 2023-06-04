{ config, lib, pkgs, ... }: let
  cfg = config.custom.desktop;
in
{
  options.custom.desktop = with lib; {
    enable = mkEnableOption "Enable system wide desktop support.";
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.mapAttrs (_: _: {
      extraGroups = [ "audio" "video" "networkmanager" ];
    }) config.home-manager.users;
    services = {
      xserver = {
        enable = true;
        layout = "es,us";
        xkbOptions = "caps:escape, grp:alt_space_toggle";
        desktopManager = {
          xfce.enable = true;
        };
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          config = ./xmonad/xmonad.hs;
        };
      };
      dbus = {
        enable = true;
        packages = [ pkgs.dconf ];
      };
      gnome.gnome-keyring.enable = true;

    };
    base = {
      sound = true;
      printing = true;
    };
    programs = {
      light.enable = true;
    };
    networking.networkmanager.enable = true;
    hardware = {
      bluetooth.enable = true;
      opengl.enable = true;
    };
    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
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
