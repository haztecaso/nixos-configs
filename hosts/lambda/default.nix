{ config, pkgs, ... }: {
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 3d";

  base = {
    hostname = "lambda";
    hostnameSymbol = "λ";
    stateVersion = "21.11";
  };

  shortcuts = {
    paths = {
      h = "~";
      cf = "~/.config";
      n = "~/nixos-configs";
    };
  };

  programs = {
    shells.aliases = {
      ".." = "cd ..";
      less = "less --quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4";
      cp = "cp -i";
      agenix = "nix run github:ryantm/agenix --";
    };
  };

  custom = {
    programs = {
      ranger.enable = false;
      nnn.bookmarks = {
        c = "~/.config";
        h = "~";
        n = "~/nixos-configs";
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
    code.enable = true;
    gitea.enable = true;
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

    netdata = {
      enable = true;
      config = {
		web = {
			"default port" = 8004;
		};
      };
    };

    nginx.virtualHosts.netdata = {
      serverName = "netdata.lambda.lan";
      locations."/".proxyPass = "http://127.0.0.1:8004";
    };
  };

  mailserver = {
    enable = true;
    fqdn = "mail.haztecaso.com";
    domains = [ "haztecaso.com" ];
    # certificateScheme = 3;
  };

}
