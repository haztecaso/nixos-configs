{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.vim;
  mkFlakeUri = config: "github:haztecaso/neovim-flake\\#${config}";
  mkRunCmd = config: "nix run ${mkFlakeUri config}";
in {
  options.custom.programs.vim = with lib; {
    package = mkOption {
      type = types.one;
      default = pkgs.nvim.core;
      description = "Neovim package to install.";
    };

    defaultConfig = mkOption {
      type = types.enum [ "core" "full" ];
      default = "core";
      description = "neovim default config (see haztecaso/neovim-flake)";
    };

    defaultEditor = mkOption {
      type = types.bool;
      default = true;
      description =
        "When enabled sets nvim as the default editor using the EDITOR environment variable.";
    };
  };

  config = lib.mkMerge [
    {
      custom.shell.aliases = {
        nvimCore = mkRunCmd "core";
        nvimFull = mkRunCmd "full";
        nvim = mkRunCmd cfg.defaultConfig;
        vim = "nvim";
        vi = "nvim";
      };
    }

    (lib.mkIf (cfg.defaultEditor) {
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    })
  ];
}
