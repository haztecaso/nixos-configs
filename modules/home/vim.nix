{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.vim;
in
{
  options.custom.programs.vim = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Wether to enable neovim editor.";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.neovimBase;
      description = "Neovim package to install.";
    };
    defaultEditor = mkOption {
      type = types.bool;
      default = true;
      description = "When enabled sets [neo]vim as the default editor using the EDITOR environment variable.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];
    })

    (lib.mkIf (cfg.defaultEditor) {
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    })
  ];
}
