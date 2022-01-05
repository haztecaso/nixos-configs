{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./services/matomo.nix
    # ./services/moodle-dl.nix
    ./services/syncthing.nix
    ./services/vaultwarden.nix
    ./websites
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
  };

  boot.cleanTmpDir = true;

  time.timeZone = "Europe/Madrid";

  networking = {
    hostName = "lambda";
    firewall = {
      allowedTCPPorts = [ 22 80 443 ];
    };
  };

  security = {
    acme = {
      acceptTerms = true;
      email = "adrianlattes@disroot.org";
    };
  };

  # virtualisation.docker = {
  #   enable = true;
  #   autoPrune = {
  #     enable = true;
  #     dates = "03:30";
  #   };
  # };

  users.users.root.openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];

  environment.systemPackages = with pkgs; [ git rsync ranger ];

  programs = {
    bash = {
      promptInit = ''export PS1="\[\e[00;34m\][\u@λ \w]\\$ \[\e[0m\]"'';
      interactiveShellInit = ''
        if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
          tmux attach-session -t lambda || tmux new-session -s lambda
        fi
      '';
      shellAliases = {
        ".." = "cd ..";
        "r" = "ranger";
      };
    };
    tmux = {
      enable = true;
      statusColor = "#aaaaee";
    };
    vim = {
      enable = true;
      defaultEditor = true;
    };
  };

  services = {
    openssh.enable = true;
    nginx = {
      enable = true;
      enableReload = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };
  };

  system.stateVersion = "21.11";
}
