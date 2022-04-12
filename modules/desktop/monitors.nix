{ config, pkgs, lib,  ... }:
let
  cfg = config.desktop.monitors;
in
  {
  options.desktop.monitors = with lib; {
    profiles = mkOption {
      type = lib.types.attrs;
      description = "Autorandr profiles specification (see home-manager module).";
      default = {};
    };
     defaultTarget = mkOption {
      type = lib.types.str;
      description = "Default profile.";
      default = "";
    };
  };
  config = lib.mkIf config.desktop.enable {
    services.autorandr = {
      enable = true;
      defaultTarget = cfg.defaultTarget;
    };
    home-manager.users.skolem = { ... }: {
      programs.autorandr = {
        enable = true;
        hooks.postswitch = {
          "polybar-restart" = "systemctl --user restart polybar";
          "hsetroot" = "${pkgs.hsetroot}/bin/hsetroot";
        };
        profiles = cfg.profiles;
      };
    };
  };
}
