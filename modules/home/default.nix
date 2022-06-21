{ config, ... }:
{
  home-manager = {
    extraSpecialArgs = { nixosConfig = config; };
    sharedModules = [{
      imports = [
        ./latex.nix
        ./mail.nix
        ./music.nix
        ./tmux.nix
        ./vim.nix
      ];
    }];
  };
}
