{ config, pkgs, ... }: {
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 3d";

  base = {
    hostname = "lambda";
    hostnameSymbol = "λ"; 
    stateVersion = "21.11";
  };

  custom = {
    shortcuts = {
      paths = {
        h  = "~";
        cf = "~/.config";
        n  = "~/nixos-configs";
      };
    };

    programs = {
      shells.aliases = {
        ".." = "cd ..";
        less = "less --quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4";
        cp = "cp -i";
        agenix = "nix run github:ryantm/agenix --";
      };
      ranger.enable = false;
      nnn.bookmarks = {
        c = "~/.config";
        h = "~";
        n = "~/nixos-configs";
        w  = "/var/www/";
      };

      tmux.color = "#aaee00";
    };

    services = {
    };


  };

  webserver = {
    enable = true;
    haztecaso.enable = true;
    elvivero.enable = true;
    matomo.enable = true;
    thumbor.enable = true;
    code.enable = true;
  };

  age.secrets = {
    "jobo_bot.conf".file = ../../secrets/jobo_bot.age;
    "moodle-dl.conf".file = ../../secrets/moodle-dl.age;
  };

  services = {
    syncthing = {
       enable    = true;
       folders   = [ "uni-moodle" "nube" "android-camara" ];
     };

    moodle-dl = {
      enable     = true;
      configFile = config.age.secrets."moodle-dl.conf".path;
      folder     = "/var/lib/syncthing/uni-moodle/";
     };

    jobo_bot = {
      enable     = true;
      frequency  = 20;
      prod       = true;
      configFile = config.age.secrets."jobo_bot.conf".path;
    };

    vaultwarden.enable = true;
  };


}
