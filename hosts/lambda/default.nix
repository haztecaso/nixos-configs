{ config, pkgs, ... }: {
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 3d";

  base = {
    hostname = "lambda";
    hostnameSymbol = "λ";
    stateVersion = "21.11";
  };

  programs = {
    shells.aliases = {
      agenix = "nix run github:ryantm/agenix --";
    };
  };

  custom = {
    programs = {
      ranger.enable = false;
      nnn.bookmarks = {
        w = "/var/www/";
      };
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
  };

  webserver = {
    enable = true;
    haztecaso.enable = true;
    elvivero.enable = true;
    matomo.enable = true;
    thumbor.enable = true;
  };

  age.secrets = {
    "jobo_bot.conf".file = ../../secrets/jobo_bot.age;
    "moodle-dl.conf".file = ../../secrets/moodle-dl.age;
  };

  services = {
    custom = {
      syncthing = {
        enable = true;
        folders = [ "uni-moodle" "nube" "android-camara" ];
      };
      tailscale.enable = true;
      vaultwarden.enable = true;
      code = {
        enable = true;
        port = 8002;
        serverName = "code.haztecaso.com";
      };
      gitea = {
        enable = true;
        port = 8003;
        serverName = "git.haztecaso.com";
      };
      netdata = {
        enable = true;
        port = 8004;
        serverName = "netdata.lambda.lan";
      };
    };

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
