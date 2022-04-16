{ config, pkgs, ... }: let
  keys = import ../../ssh-keys.nix;
in
{
  imports = [ ./hardware.nix ./monitors.nix ];

  nix.gc.options = "--delete-older-than 18d";

  home-manager.users.skolem = { ... }: {
    services.syncthing.enable = true;
    home.packages = with pkgs; [ beancount fava ];
  };

  environment.systemPackages = with pkgs; [
      unstable.yt-dlp
  ];

  base = {
    hostname = "beta";
    hostnameSymbol = "β";
    wlp = { interface = "wlp3s0"; useDHCP = true; };
    eth.interface = "enp0s31f6";
    stateVersion = "21.11";
  };

  shortcuts = {
    paths = {
      D  = "~/Downloads";
      N  = "~/Nube";
      cf = "~/.config";
      d  = "~/Documents";
      l  = "~/Nube/lecturas";
      mm = "~/Music";
      mo = "~/Nube/money";
      n  = "~/nixos-configs";
      pp = "~/Pictures";
      sr = "~/src";
      u  = "~/Nube/uni/Actuales";
      vv = "~/Videos";
    };
    uni = {
      enable = true;
      asignaturas = [ "tpro" "gcomp" "afvc" "topo" ];
    };
  };

  desktop = {
    enable = true;
    bat = "BAT1";
    fontSize = 8;
  };

  programs = {
    shells.aliases = {
      ".." = "cd ..";
      less = "less --quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4";
      cp = "cp -i";
      ytdl = "yt-dlp";
      youtube-dl = "yt-dlp";
      python = "${pkgs.python38Packages.ipython}/bin/ipython";
      };
  };

  services = {
    custom.tailscale.enable = true;
  };


  custom = {
    programs = {
      ranger.enable = false;
      nnn.bookmarks = {
        D = "~/Downloads";
        N = "~/Nube";
        c = "~/.config";
        d = "~/Documents";
        h = "~";
        l = "~/Nube/lecturas";
        m = "~/Music";
        n = "~/nixos-configs";
        p = "~/Pictures";
        s = "~/src";
        u = "~/Nube/uni/Actuales";
        v = "~/Videos";
      };
      tmux.color = "#aaee00";
      vim.package = pkgs.neovimFull;
      music.enable = true;
      latex.enable = true;
      irssi.enable = true;
    };

    dev = {
      enable = true;
      pythonPackages = [
        "numpy"
        "matplotlib"
        "ipython"
      ];
      direnv.enable = true;
    };

  };
}
