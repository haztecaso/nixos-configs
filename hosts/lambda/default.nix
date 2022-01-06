{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./services/matomo.nix
    # ./services/moodle-dl.nix
    ./services/syncthing.nix
    ./services/vaultwarden.nix
    ./websites
  ];

  nix.gc.options = "--delete-older-than 3d";

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
    vim.defaultEditor = true;
  };

  custom = {
    stateVersion = "21.11";
    base.tmux.color = "#eeaa00";
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

}
