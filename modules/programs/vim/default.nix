{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.vim;
  plugins = (import ./plugins.nix) { vimPlugins = pkgs.vimPlugins; inherit pkgs; };
  vim-config = {
    programs.vim = {
      enable = true;
      plugins = plugins.vim; 
      extraConfig = (builtins.readFile ./common.vim) + (builtins.readFile ./vim.vim);
    };
  };
  neovim-config = {
    programs.neovim = {
      enable = true;
      withNodeJs = true;
      plugins = plugins.neovim; 
      extraConfig = (builtins.readFile ./common.vim) + (builtins.readFile ./neovim.vim);
      coc = {
        enable = true;
        settings = (import ./coc.nix) { inherit pkgs; };
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
