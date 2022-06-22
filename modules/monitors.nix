{ config, pkgs, lib, ... }:
let
  cfg = config.custom.monitors;
in
{
  options.custom.monitors = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Wether to enable monitor support with autorandr.";
    };
    profiles = mkOption {
      type = types.attrs;
      description = "Autorandr profiles specification (see home-manager module).";
      default = { };
    };
    defaultTarget = mkOption {
      type = types.str;
      description = "Default profile.";
      default = "";
    };
  };
  config = lib.mkIf cfg.enable {
    services.autorandr = {
      enable = true;
      defaultTarget = cfg.defaultTarget;
    };
  };
}
