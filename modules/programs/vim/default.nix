{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.vim;
  vim-config = {
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ gruvbox vim-commentary vim-fugitive vim-lastplace vim-vinegar vim-nix ];
      extraConfig = (builtins.readFile ./common.vim);
    };
  };
  neovim-config = {
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ gruvbox vim-commentary vim-fugitive vim-lastplace vim-vinegar vim-nix ];
      extraConfig = (builtins.readFile ./common.vim);
      coc = {
        enable = true;
      };
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };
  mkHomeConfig = conf: {
    home-manager.users = {
      skolem = { ... }: conf;
      root   = { ... }: conf;
    };
  };
  mkVimConfig = pkg: lib.mkIf (cfg.package == pkg) (mkHomeConfig (if pkg == "vim" then vim-config else neovim-config));
  bin = pkg: if pkg == "neovim" then "nvim" else pkg;
  mkVariablesConfig = pkg: lib.mkIf (cfg.package == pkg && cfg.defaultEditor) (mkHomeConfig {
    home.sessionVariables = {
      EDITOR = bin pkg;
      VISUAL = bin pkg;
    };
  });
in
{
  options.custom.programs.vim = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable [neo]vim editor";
    };
    defaultEditor = mkOption {
      type = types.bool;
      default = true;
      description = "When enabled configs [neo]vim as the default editor using the EDITOR environment variable.";
    };
    package = mkOption {
      type = types.enum [ "vim" "neovim" ];
      default = "vim";
    };
  };

  config = lib.mkMerge [
    (mkVimConfig "vim")
    (mkVimConfig "neovim")
    (mkVariablesConfig "vim")
    (mkVariablesConfig "neovim")
  ];
}
