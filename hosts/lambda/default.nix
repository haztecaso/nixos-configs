{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    # ./networking.nix
    ./borg-backup.nix
    ./web
  ];

  users.users = with config.base.ssh-keys; {
    root.openssh.authorizedKeys.keys = [ skolem ];
    skolem.openssh.authorizedKeys.keys = [ skolem termux skolem_elbrus skolem_mac ];
  };

  nix.gc.options = "--delete-older-than 3d";

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
        nnn.bookmarks = { w = "/var/www/"; };
      };
    };
  };

  base = {
    hostname = "lambda";
    hostnameSymbol = "λ";
    stateVersion = "22.11";
  };

  environment.systemPackages = with pkgs; [ agenix ];

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
      radicale.enable = true;
      syncthing = { 
        enable = true; 
        folders = [ "uni-moodle" "nube" "android-camara" "vault" "zotero-storage" ]; 
      };
      tailscale.enable = true;
    };
  };

  age.secrets = {
    "jobo_bot.conf".file = ../../secrets/jobo_bot.age;
    "remadbot.conf".file = ../../secrets/remadbot.age;
    "moodle-dl.conf".file = ../../secrets/moodle-dl.age;
  };

  services = {

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

    # radicale =
    #   let
    #     htpasswd = pkgs.writeText "radicale.users" (concatStrings
    #       (flip mapAttrsToList config.mailserver.loginAccounts (mail: user:
    #         mail + ":" + user.hashedPassword + "\n"
    #       ))
    #     );
    #   in
    #   {
    #     enable = true;
    #     config = ''
    #       [auth]
    #       type = htpasswd
    #       htpasswd_filename = ${htpasswd}
    #       htpasswd_encryption = bcrypt
    #     '';
    #   };
    
      # nginx.virtualHosts."dav.haztecaso.com" = {
      # };

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

