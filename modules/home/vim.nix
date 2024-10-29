{ lib, config, inputs, system, ... }:
let cfg = config.custom.programs.vim;
in {
  options.custom.programs.vim = with lib; {
    defaultConfig = mkOption {
      type = types.enum [ "core" "full" null ];
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
    (lib.mkIf (cfg.defaultConfig != null) {
      home.packages =
        [ inputs.neovim-flake.packages.${system}.${cfg.defaultConfig} ];
      custom.shell.aliases = {
        vim = "nvim";
        vi = "nvim";
      };
    })

    (lib.mkIf (cfg.defaultEditor) {
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    })
  ];
}
