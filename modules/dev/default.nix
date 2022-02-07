{ config, lib, pkgs, ... }:
{
  options.custom.dev = {
    enable = lib.mkEnableOption "Custom desktop environment (wm: xmonad)";
  };

  config = lib.mkIf config.custom.dev.enable {

      environment.systemPackages = with pkgs; [
        python38
        ag
        git
      ];

  };
}
