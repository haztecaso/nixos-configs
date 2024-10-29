{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./hydra.nix
    ./media.nix
    ./music.nix
    ./navidrome.nix
    ./nextcloud.nix
  ];

  nix.gc.options = "--delete-older-than 60d";

  users.users.skolem.openssh.authorizedKeys.keys = with config.base.ssh-keys; [
    skolem
    termux
    skolem_elbrus
    skolem_lambda
    skolem_deambulante
  ];

  base = {
    hostname = "nas";
    hostnameSymbol = "ν";
    stateVersion = "23.11";
  };

  home-manager.users = {
    root = { ... }: { custom.programs = { tmux.color = "#aa0022"; }; };
    skolem = { ... }: { custom.programs = { tmux.color = "#aa00ee"; }; };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    agenix
    borgbackup
    ffmpeg
    openai-whisper-cpp
  ];

  programs = { mosh.enable = true; };

  virtualisation = { docker.enable = true; };

  services = {
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      guiAddress = "0.0.0.0:8384";
    };
    meshcentral = {
      enable = false; # TODO: config properly
      settings = {
        settings = {
          cert = "remote.bufanda.cc";
          tlsOffload = "10.0.0.1";
          WANonly = true;
          port = 4001;
          aliasPort = 443;
        };
      };
    };
  };

  custom.services = {
    fava = {
      enable = true;
      hostname = "0.0.0.0";
      port = 4000;
      openPort = true;
      beancountFile = "/var/lib/syncthing/nube/money/ledger.book";
    };
    tailscale.enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 111 4001 5000 50000 ];
    allowedUDPPorts = [ 111 4001 50000 ];
  };

}
