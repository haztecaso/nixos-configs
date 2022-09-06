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
        music.server = {
          enable = true;
          library = /mnt/raid/music/Library;
        };
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

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud24;
      appstoreEnable = false;
      hostName = "cloud.elvivero.es";
      # https = true;
      datadir = "/mnt/raid/nextcloud";
      config = {
        adminpassFile = "/mnt/raid/nextcloud-admin-pass";
        defaultPhoneRegion = "ES";
        extraTrustedDomains = ["nas"];
      };
    };
  };

  services.hydra = {
    enable = true;
    hydraURL = "http://nas:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 443 111 2049 3000 4000 8000 4001 4002 20048 ];
    allowedUDPPorts = [ 80 443 111 2049 3000 4000 8000 4001 4002 20048 ];
  };

}
