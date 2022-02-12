{ config, pkgs, lib,  ... }:
let
  cfg = config.custom.desktop.monitors;
in
  {
  options.custom.desktop.monitors = with lib; {
    profiles = mkOption {
      type = lib.types.attrs;
      description = "Autorandr profiles specification (see home-manager module).";
    };
     defaultTarget = mkOption {
      type = lib.types.str;
      default = "";
    };
  };
  config = lib.mkIf config.custom.desktop.enable {
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
