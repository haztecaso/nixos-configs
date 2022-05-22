{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.git;
in
{
  options.custom.programs.git = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.home-manager.users =
    let
      config = {
        programs.git = {
          enable = true;
          userEmail = "adrianlattes@disroot.org";
          userName = "haztecaso";
          lfs.enable = true;
        };
      };
    in
    lib.mkIf cfg.enable {
      skolem = { ... }: config;
    };

}
