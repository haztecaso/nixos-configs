{ config, pkgs, ... }: {
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 14d";

  home-manager.users = let
    vim = pkgs.mkNeovim {
      completion.enable = true;
      snippets.enable = true;
      plugins = {
        latex = false;
        nvim-which-key = false;
      };
    };
  in {
    root = { ... }: {
      custom.programs = {
        tmux.color = "#aaee00";
        vim.package = vim;
      };
    };
    skolem = { ... }: {
      custom.programs = {
        tmux.color = "#aaee00";
        vim.package = vim;
      };
    };
  };

  base = {
    hostname = "nas";
    hostnameSymbol = "ν";
    stateVersion = "21.05";
  };

  programs = {
    mosh.enable = true;
  };

  custom = {
    services = {
        tailscale.enable = true;
    };
  };

  # Network shares

  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/raid *(insecure,no_subtree_check)
    '';
    hostName = "nas";
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];

}
