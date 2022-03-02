{ config, lib, pkgs, ... }:
let
  cfg = config.custom.dev;
  pythonPackageNames = lib.attrNames pkgs.python38Packages;
  pythonPackages = map (name: pkgs.python38Packages.${name}) cfg.pythonPackages;
in
{
  options.custom.dev = with lib; {
    enable = mkEnableOption "Custom desktop environment (wm: xmonad)";
    pythonPackages = mkOption {
      type = types.enum pythonPackageNames;
      default = [];
      description = "Set of python packages to install globally";
    };
  };

  config = lib.mkIf config.custom.dev.enable {
      environment.systemPackages = with pkgs; [
        wget
        axel
        python38
        ag
        jq
        git
        dust
        ncdu
        python38Full
      ] ++ pythonPackages;
  };
}
