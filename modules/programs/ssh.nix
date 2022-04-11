{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.ssh;
in
{
  options.custom.programs.tmux = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.home-manager.users = let
      config = {
        programs.ssh = {
          enable = true;
          matchBlocks = {
          };
        };
      };
    in lib.mkIf cfg.enable {
      skolem = { ... }: config;
      root = { ... }: config;
    };

}
