{ config, pkgs, ... }:
let
  cfg = config.custom.desktop.monitors;
in
  {
  options.custom.desktop.monitors = {
    primary = lib.mkOption {
      type = lib.types.str;
      description = "Output name to EDID mapping. Use autorandr --fingerprint to get current setup values."
    };
    secondary = lib.mkOption {
      type = lib.types.str;
      description = "Output name to EDID mapping. Use autorandr --fingerprint to get current setup values."
    };
  };
  config = lib.mkIf config.custom.desktop.enable {
    home-manager.users.skolem = { ... }: {
      programs.autorandr = {
        enable = true;
        hooks.postswitch = {
          "polybar-restart" = "systemctl --user restart polybar";
          "hsetroot" = "${pkgs.hsetroot}/bin/hsetroot";
        };
        profiles = {
          onlyprimary = {
            fingerprint.primary = cfg.primary;
            config = {
              primary = {
                enable = true;
                crtc = 1;
                primary = true;
                position = "0x0";
                mode = "1280x800";
                rate = "60.22";
              };
            };
          };
          onlysecondary = {
            fingerprint = {
              primary = cfg.primary;
              secondary = cfg.secondary;
            };
            config = {
              primary.enable = false;
              secondary = {
                enable = true;
                crtc = 0;
                primary = true;
                position = "0x0";
                mode = "2560x1440";
                rate = "59.95";
              };
            };
          };
        };
      };
    };
  };
}
