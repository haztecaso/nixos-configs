{ nixosConfig, config, pkgs, lib, ... }:
let
  cfg = nixosConfig.custom.monitors;
in
{
  config = lib.mkIf cfg.enable {
    programs.autorandr = {
      enable = true;
      hooks.postswitch = {
        "polybar-restart" = "systemctl --user restart polybar";
        "hsetroot" = "${pkgs.hsetroot}/bin/hsetroot";
      };
      profiles = cfg.profiles;
    };
  };
}
