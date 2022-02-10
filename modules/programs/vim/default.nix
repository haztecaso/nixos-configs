{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.vim;
  vim-config = {
  };
in
{
  options.custom.programs.vim = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable [neo]vim editor";
    };
    defaultEditor = mkEnableOption "When enabled configs [neo]vim as the default editor using the EDITOR environment variable.";
    package = mkOption {
      type = types.enum [ "vim" "neovim" ];
      default = "vim";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.package == "vim") {
      programs.vim.package = pkgs.vim_configurable.customize {
      name = "vim";
      vimrcConfig = {
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [ gruvbox vim-commentary vim-fugitive vim-lastplace vim-vinegar ];
          opt = [ vim-nix ];
        };
        customRC = (builtins.readFile ./common.vim);
        };
      };
      environment.systemPackages = with pkgs; [ config.programs.vim.package ];
    })
  ];
}
