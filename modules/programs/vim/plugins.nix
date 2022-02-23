{ vimPlugins, pkgs }: with vimPlugins; rec {
  vim = [
    # ack-vim #TODO: include ack-vim with config in vim
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
      plugin = ack-vim;
      config = ''
        let g:ackprg = '${pkgs.ag}/bin/ag --vimgrep'
        map <leader>f :Ack! 
      '';
    }
    {
      plugin = vimtex;
      config = ''
        let g:tex_flavor='latex'
        let g:vimtex_view_method = 'zathura'
        let g:vimtex_quickfix_mode=1
        let g:vimtex_quickfix_open_on_warning = 0
        let g:vimtex_imaps_leader = 'ñ'
        set conceallevel=1
        " let g:tex_conceal='abmg'
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
