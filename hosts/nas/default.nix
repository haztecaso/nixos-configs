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

  fileSystems = {
    "/export/raid" = {
      device = "/mnt/raid";
      options = [ "bind" ];
    };
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export *(rw,fsid=0,no_subtree_check)
      /export/raid *(rw,insecure,nohide,no_subtree_check)
    '';
    hostName = "nas";
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];

}
