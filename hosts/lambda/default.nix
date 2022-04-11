{ pkgs, ... }: {
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 3d";

  custom = {
    base = {
      hostname = "lambda";
      hostnameSymbol = "λ"; 
    };

    shortcuts= {
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
      vaultwarden.enable = true;
      syncthing = {
         enable = true;
         folders = [ "uni-moodle" "nube" "android-camara" ];
       };
      moodle-dl.enable = true;
      jobo_bot = {
        enable = true;
        frequency = 20;
        prod = true;
      };
    };

    webserver = {
      enable = true;
      haztecaso.enable = true;
      lagransala.enable = false; #TODO: setup dns
      elvivero.enable = true;
      matomo.enable = true;
      thumbor.enable = true;
    };

    stateVersion = "21.11";
  };

}
