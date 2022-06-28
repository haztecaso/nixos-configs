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
        layout = "es";
        xkbOptions = "caps:escape";
        desktopManager = {
          xfce.enable = true;
        };
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
      dbus = {
        enable = true;
        packages = [ pkgs.dconf ];
      };
      gnome.gnome-keyring.enable = true;

    };
    custom.base = {
      sound = true;
      printing = true;
    };
    programs = {
      light.enable = true;
    };
    networking.networkmanager.enable = true;
    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
        # google-fonts
        dejavu_fonts
        noto-fonts
        noto-fonts-emoji
        font-awesome
        (nerdfonts.override { fonts = [ "Hack" "LiberationMono" ]; })
      ];
    };
    security = {
      pam.services.gdm.enableGnomeKeyring = true;
    };
  };
}
