{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.vim;
  common_plugins = with pkgs.vimPlugins; [
  ];
  neovim_plugins = with pkgs.vimPlugins; [
    { plugin = vimtex;
      config = ''
        let g:tex_flavor='latex'
        let g:vimtex_view_method = 'zathura'
        let g:vimtex_quickfix_mode=1
        let g:vimtex_quickfix_open_on_warning = 0
        let g:vimtex_imaps_leader = 'ñ'
        let g:vimtex_quickfix_latexlog = {
          \ 'default' : 1,
          \ 'general' : 1,
          \ 'references' : 1,
          \ 'overfull' : 1,
          \ 'underfull' : 1,
          \ 'font' : 0,
          \ 'packages' : {
          \   'default' : 1,
          \   'general' : 1,
          \   'babel' : 1,
          \   'biblatex' : 1,
          \   'fixltx2e' : 1,
          \   'hyperref' : 1,
          \   'natbib' : 1,
          \   'scrreprt' : 1,
          \   'titlesec' : 1,
          \ },
          \}
        set conceallevel=1
        let g:tex_conceal='abmg'
      '';
    }
    coc-nvim
    coc-json
    coc-yaml
    coc-explorer
    coc-snippets
    coc-prettier
    coc-git
    coc-texlab
    coc-html
    coc-css
    coc-pyright
    coc-tsserver
    # coc-tailwindcss
    # coc-sh
  ];
  vim-config = {
    programs.vim = {
      enable = true;
      plugins = common_plugins; 
      extraConfig = (builtins.readFile ./common.vim) + (builtins.readFile ./vim.vim);
    };
  };
  neovim-config = {
    programs.neovim = {
      enable = true;
      withNodeJs = true;
      plugins = common_plugins ++ neovim_plugins; 
      extraConfig = (builtins.readFile ./common.vim) + (builtins.readFile ./neovim.vim);
      coc = {
        enable = true;
        settings = {
          languageserver = {
          };
        };
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
