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
        music = {
          enable = true;
          library = "/mnt/raid/music/Library";
        };
      };
    };
  };

  base = {
    hostname = "nas";
    hostnameSymbol = "ν";
    stateVersion = "21.05";
    printing = true;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  programs = {
    mosh.enable = true;
  };

  virtualisation = {
    docker.enable = true;
  };

  custom = {
    services = {
        syncthing = {
            enable = true;
            folders = [ "uni-moodle" "nube" "android-camara" ];
        };
        tailscale.enable = true;
        music-server = {
          enable = true;
          library = "/mnt/raid/music/Library";
        };
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

  # services.printing.browsing = true;
  # services.printing.listenAddresses = [ "*:631" ]; # Not 100% sure this is needed and you might want to restrict to the local network
  # services.printing.allowFrom = [ "all" ]; # this gives access to anyone on the interface you might want to limit it see the official documentation
  # services.printing.defaultShared = true; # If you want
  # services.printing.clientConf = ''
  #     Encryption Never
  # '';

  services.navidrome = {
      enable = true;
      settings = {
          Address = "0.0.0.0";
          Port = 4747;
          MusicFolder = "/mnt/raid/music/Library/";
          PlaylistsPath = "/mnt/raid/music/Library/Playlists/";
          EnableCoverAnimation = false;
          AuthWindowLength = "60s";
      };
  };
  users.groups.navidrome = { };
  users.users.navidrome = {
      isSystemUser = true;
      group = "navidrome";
      extraGroups = [ "users" ];
  };

  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;


  services.hydra = {
    enable = true;
    hydraURL = "http://nas:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 631 443 111 2049 3000 4000 8000 4001 4002 20048 ];
    allowedUDPPorts = [ 80 631 443 111 2049 3000 4000 8000 4001 4002 20048 ];
  };

}
