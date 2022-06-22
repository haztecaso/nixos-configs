{ config, pkgs, lib, ... }:
let
  cfg = config.custom.programs.money;
in
{
  options.custom.programs.money = with lib; {
    enable = mkEnableOption "Install beancount and fava packages.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ beancount fava ];
  };
}
