{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    # ./networking.nix
    ./web
    ./radicale.nix
  ];

  users.users = with config.base.ssh-keys; {
    root.openssh.authorizedKeys.keys = [ skolem ];
    skolem.openssh.authorizedKeys.keys = [ skolem termux skolem_elbrus skolem_mac ];
  };

  nix.gc.options = "--delete-older-than 3d";

  home-manager.users = {
    root = { ... }: {
      custom.programs = {
        tmux.color = "#aaee00";
      };
    };
    skolem = { ... }: {
      custom.programs = {
        tmux.color = "#aaee00";
        nnn.bookmarks = { w = "/var/www/"; };
      };
    };
  };

  base = {
    hostname = "lambda";
    hostnameSymbol = "λ";
    stateVersion = "23.05";
  };

  environment.systemPackages = with pkgs; [ agenix borgbackup ];

  programs = {
    mosh.enable = true;
  };

  custom = {
    services = {
      gitea.enable = true;
      # moodle-dl = { 
      #   enable = true; 
      #   configFile = config.age.secrets."moodle-dl.conf".path; 
      #   folder = "/var/lib/syncthing/uni-moodle/";
      # };
      netdata.enable = true;
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

    jobo_bot = {
      enable = true;
      frequency = 20;
      prod = true;
      configFile = config.age.secrets."jobo_bot.conf".path;
    };

    remadbot = {
      enable = true;
      frequency = 15;
      prod = true;
      configFile = config.age.secrets."remadbot.conf".path;
    };

    # roundcube = {
    #   enable = false;
    #   hostName = "mail.haztecaso.com";
    #   extraConfig = ''
    #     # starttls needed for authentication, so the fqdn required to match the certificate
    #     $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
    #     $config['smtp_user'] = "%u";
    #     $config['smtp_pass'] = "%p";
    #   '';
    #   package = pkgs.roundcube.withPlugins (p: with p; [ persistent_login ]);
    #   plugins = [
    #     "archive"
    #     "hide_blockquote"
    #     "newmail_notifier"
    #     "show_additional_headers"
    #     "zipdownload"
    #     "persistent_login"
    #   ];
    # };

    # headscale = {
    #   enable = true;
    #   port = 8004;
    #   settings = {
    #     tls_cert_path = "${config.security.acme.certs."headscale.haztecaso.com".directory}/certfile";
    #     tls_key_path = "${config.security.acme.certs."headscale.haztecaso.com".directory}/keyfile";
    #   };
    # };

    # nginx.virtualHosts.headscale = {
    #   enableACME = true;
    #   forceSSL = true;
    #   serverName = "headscale.haztecaso.com";
    #   locations."/".proxyPass = "http://127.0.0.1:8004";
    # };
  };

  # mailserver = {
  #   enable = true;
  #   fqdn = "mail.haztecaso.com";
  #   domains = [ "haztecaso.com" ];
  #   # certificateScheme = 3;
  # };
}

