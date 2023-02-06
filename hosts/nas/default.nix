{ config, pkgs, ... }: {
  imports = [ 
    ./hardware.nix 
    # ./hydra.nix
    # ./nextcloud.nix
    ./navidrome.nix
  ];

  nix.gc.options = "--delete-older-than 60d";

  base = {
    hostname = "nas";
    hostnameSymbol = "ν";
    stateVersion = "22.11";
  };

  home-manager.users = let
    vim = pkgs.mkNeovim {
      completion.enable = true;
      snippets.enable = true;
      plugins = {
        latex = false;
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

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  programs = {
    mosh.enable = true;
  };

  virtualisation = {
    docker.enable = true;
  };

  services.nix-serve = {
    enable = true;
    port = 5555;
    openFirewall = true;
  };

  custom.services = {
    syncthing = {
      enable = true;
      folders = [ "uni-moodle" "nube" "android-camara" ];
    };
    fava = {
      enable = true;
      hostname = "0.0.0.0";
      port = 4000;
      openPort = true;
      beancountFile = "/var/lib/syncthing/nube/money/ledger.book";
    };
    tailscale.enable = true;
    music-server = {
      enable = true;
      library = "/mnt/raid/music/Library";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 631 443 111 2049 8000 4001 4002 20048 50000 ];
    allowedUDPPorts = [ 80 631 443 111 2049 8000 4001 4002 20048 50000 ];
  };

}
