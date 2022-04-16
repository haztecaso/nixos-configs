{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.vim;
  mkHomeConfig = conf: {
    home-manager.users = {
      skolem = { ... }: conf;
      root = { ... }: conf;
    };
  };
in
{
  options.custom.programs.vim = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable neovim editor";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.neovimBase;
      description = "Neovim package to install";
    };
    defaultEditor = mkOption {
      type = types.bool;
      default = true;
      description = "When enabled configs [neo]vim as the default editor using the EDITOR environment variable.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable (mkHomeConfig {
      home.packages = [ cfg.package ];
    }))
    (lib.mkIf (cfg.defaultEditor) (mkHomeConfig {
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    }))
  ];
}
