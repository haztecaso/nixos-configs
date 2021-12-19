{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./services/matomo.nix
    ./services/vaultwarden.nix
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

  users.users.root.openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];

  environment = {
    systemPackages = with pkgs; [ git vim rsync ];
  };

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      customPaneNavigationAndResize = true;
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
