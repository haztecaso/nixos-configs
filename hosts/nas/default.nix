{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    # ./hydra.nix
    ./media.nix 
    # ./nextcloud.nix
    ./navidrome.nix
  ];

  nix.gc.options = "--delete-older-than 60d";

  users.users.skolem.openssh.authorizedKeys.keys = with config.base.ssh-keys;
    [ skolem termux skolem_elbrus skolem_mac skolem_lambda skolem_lambda ];

  base = {
    hostname = "nas";
    hostnameSymbol = "ν";
    stateVersion = "23.05";
  };

  home-manager.users = {
    root = { ... }: {
      custom.programs = {
        tmux.color = "#aaee00";
      };
    };
    skolem = { ... }: {
      custom.programs = {
        tmux.color = "#aaee00";
        music = {
          enable = true;
          library = "/mnt/raid/music/Library";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    agenix
    borgbackup
    ffmpeg
    openai-whisper-cpp
  ];

  programs = {
    mosh.enable = true;
  };

  virtualisation = {
    docker.enable = true;
  };

  custom.services = {
    syncthing = {
      enable = true;
      folders = [ "uni-moodle" "nube" "android-camara" "vault" "zotero-storage" ];
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
    allowedTCPPorts = [ 111 4001 5000 50000 ];
    allowedUDPPorts = [ 111 4001 50000 ];
  };

}
