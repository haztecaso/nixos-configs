{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    # ./networking.nix
    ./web
    ./radicale.nix
    ./vaultwarden.nix
    # ./gitea.nix
    # ./ulogger.nix
  ];

  users.users = with config.base.ssh-keys; {
    root.openssh.authorizedKeys.keys = [ skolem ];
    skolem.openssh.authorizedKeys.keys = [
      skolem
      termux
      skolem_elbrus
      skolem_deambulante
      skolem_tejo
    ];
  };

  nix.gc.options = "--delete-older-than 3d";

  home-manager.users = {
    root = { ... }: { custom.programs = { tmux.color = "#112277"; }; };
    skolem = { ... }: {
      custom.programs = {
        tmux.color = "#0055aa";
        nnn.bookmarks = { w = "/var/www/"; };
      };
    };
  };

  base = {
    hostname = "lambda";
    hostnameSymbol = "λ";
    stateVersion = "23.05";
  };

  environment.systemPackages = with pkgs; [ borgbackup ];

  programs = { mosh.enable = true; };

  custom = {
    services = {
      # netdata.enable = true;
      # moodle-dl = { 
      #   enable = true; 
      #   configFile = config.age.secrets."moodle-dl.conf".path; 
      #   folder = "/var/lib/syncthing/uni-moodle/";
      # };
      tailscale.enable = true;
    };
  };

  age.secrets = {
    "jobo_bot.conf".file = ../../secrets/jobo_bot.age;
    "remadbot.conf".file = ../../secrets/remadbot.age;
    "moodle-dl.conf".file = ../../secrets/moodle-dl.age;
  };

  services = {
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      guiAddress = "0.0.0.0:8384";
    };

    # jobo_bot = {
    #   enable = true;
    #   frequency = 20;
    #   prod = true;
    #   configFile = config.age.secrets."jobo_bot.conf".path;
    # };

    # remadbot = {
    #   enable = true;
    #   frequency = 15;
    #   prod = true;
    #   configFile = config.age.secrets."remadbot.conf".path;
    # };
  };
}

