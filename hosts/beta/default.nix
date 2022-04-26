{ config, pkgs, ... }:
let
  keys = import ../../ssh-keys.nix;
in
{
  imports = [ ./hardware.nix ./monitors.nix ];

  nix.gc.options = "--delete-older-than 18d";

  home-manager.users.skolem = { ... }: {
    services.syncthing.enable = true;
    home.packages = with pkgs; [ beancount fava ];
    programs.gpg.enable = true;
    services.gpg-agent.enable = true;
    programs.kitty = {
      enable = true;
    };
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
      N = "~/Nube";
      l = "~/Nube/lecturas";
      mo = "~/Nube/money";
      u = "~/Nube/uni/Actuales";
    };
    uni = {
      enable = true;
    };
  };

  desktop = {
    enable = true;
    bat = "BAT1";
    fontSize = 8;
  };

  programs = {
    shells.aliases = {
      ytdl = "yt-dlp";
      youtube-dl = "yt-dlp";
      python = "${pkgs.python38Packages.ipython}/bin/ipython";
    };
    steam.enable = true;
  };

  services.custom.tailscale.enable = true;

  custom = {
    programs = {
      irssi.enable = true;
      latex.enable = true;
      music.enable = true;
      nnn.bookmarks = {
        N = "~/Nube";
        l = "~/Nube/lecturas";
        m = "~/Music";
        n = "~/nixos-configs";
        p = "~/Pictures";
        s = "~/src";
        u = "~/Nube/uni/Actuales";
        v = "~/Videos";
      };
      ranger.enable = false;
      ssh.enable = true;
      tmux.color = "#aaee00";
      vim.package = pkgs.neovimFull;
    };

    dev = {
      enable = true;
      pythonPackages = [ "numpy" "matplotlib" "ipython" ];
      direnv.enable = true;
    };
  };

}
