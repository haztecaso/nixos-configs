{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.programs.vim;
in {
  options.programs.vim = {
    enable = mkEnableOption "install vim package";
    greeter = mkOption {
      type = types.str;
      default = "world";
    };
    // package and defaultEditor are already defined in nixpkgs
  };

  config = mkIf cfg.enable {
    cfg.package = pkgs.vim_configurable.customize {
      name = "vim-with-plugins";
    };
    environment.systemPackages = with pkgs; [ cfg.package ];
  };
}
