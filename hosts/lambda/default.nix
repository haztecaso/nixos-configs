{ pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./services/matomo.nix
    # ./services/moodle-dl.nix
    ./services/syncthing.nix
    ./services/vaultwarden.nix
    ./websites
  ];

  nix.gc.options = "--delete-older-than 3d";

  networking = {
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

  programs = {
    bash = {
      promptInit = ''export PS1="\[\e[00;34m\][\u@λ \w]\\$ \[\e[0m\]"'';
    };
    vim.defaultEditor = true;
  };

  custom = {
    stateVersion = "21.11";
    base = {
      hostname = "lambda";
      tmux.color = "#eeaa00";
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

}
