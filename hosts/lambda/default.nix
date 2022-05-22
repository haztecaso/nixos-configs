{ config, pkgs, ... }: {
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 3d";

  base = {
    hostname = "lambda";
    hostnameSymbol = "λ";
    stateVersion = "21.11";
  };

  environment.systemPackages = with pkgs; [
    agenix
  ];

  programs = {
    mosh.enable = true;
  };

  custom = {
    programs = {
      ranger.enable = false;
      nnn.bookmarks = {
        w = "/var/www/";
      };
      ssh.enable = true;
      tmux.color = "#aaee00";
      vim.package = pkgs.mkNeovim {
        completion.enable = true;
        snippets.enable = true;
        plugins = {
          latex = false;
          nvim-which-key = false;
        };
      };
    };
    services = {
        syncthing = {
          enable = true;
          folders = [ "uni-moodle" "nube" "android-camara" ];
        };
        tailscale.enable = true;
        vaultwarden.enable = true;
        code-server.enable = false;
        gitea.enable = true;
        netdata.enable = true;
    };
  };

  webserver = {
    enable = true;
    colchonreview.enable = true;
    elvivero.enable = true;
    haztecaso.enable = true;
    matomo.enable = true;
    thumbor.enable = true;
    zulmarecchini.enable = true;
  };

  age.secrets = {
    "jobo_bot.conf".file = ../../secrets/jobo_bot.age;
    "moodle-dl.conf".file = ../../secrets/moodle-dl.age;
  };


  services = {
    moodle-dl = {
      enable = true;
      configFile = config.age.secrets."moodle-dl.conf".path;
      folder = "/var/lib/syncthing/uni-moodle/";
    };

    jobo_bot = {
      enable = true;
      frequency = 20;
      prod = true;
      configFile = config.age.secrets."jobo_bot.conf".path;
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

  mailserver = {
    enable = true;
    fqdn = "mail.haztecaso.com";
    domains = [ "haztecaso.com" ];
    # certificateScheme = 3;
  };


}
