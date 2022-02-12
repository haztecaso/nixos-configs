{ vimPlugins, pkgs }: with vimPlugins; rec {
  vim = [
    ack-vim
    gruvbox
    vim-commentary
    vim-easymotion
    vim-fugitive
    vim-lastplace
    vim-nix
    vim-vinegar
    # vim-endwise #incompatible with coc
  ];
  neovim = vim ++ [
    {
      plugin = vimtex;
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
    {
      plugin = vim-airline;
      config = ''
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_symbols_ascii = 1
      '';
    }
    {
      plugin = ctrlp;
      config = ''
        let g:ctrlp_show_hidden = 1
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
}
