{ config, pkgs, ... }:
let
  keys = import ../../ssh-keys.nix;
in
{
  imports = [
    ./hardware.nix
    # ./monitors.nix
  ];

  nix.gc.options = "--delete-older-than 18d";

  home-manager.users.skolem = { ... }: {
    services.syncthing.enable = true;
    home.packages = with pkgs; [
      beancount
      fava
      unstable.yt-dlp
    ];
  };

  base = {
    hostname = "galois";
    hostnameSymbol = "G";
    wlp = { interface = "wlp2s0"; useDHCP = true; };
    eth.interface = "enp1s0f0";
    stateVersion = "21.11";
  };

  shortcuts = {
    paths = {
      D = "~/Downloads";
      N = "~/Sync";
      cf = "~/.config";
      d = "~/Documents";
      l = "~/Nube/lecturas";
      mm = "~/Music";
      mo = "~/Nube/money";
      n = "~/etc/nixos";
      pp = "~/Pictures";
      sr = "~/src";
      u = "~/Sync/uni/Actuales";
      vv = "~/Videos";
    };
    uni = {
      enable = true;
      asignaturas = [ "tpro" "gcomp" "afvc" "topo" ];
    };
  };

  desktop = {
    enable = true;
    bat = "BAT0";
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
    adb.enable = true;
    mosh.enable = true;
  };

  services = {
    custom.tailscale.enable = true;
    logind.extraConfig = "HandlePowerKey=suspend";
    upower.enable = true;
    avahi.enable = true;
    avahi.nssmdns = true;
  };

  virtualisation = {
    virtualbox.host.enable = true;
    # virtualbox.host.enableExtensionPack = true;
    docker.enable = true;
  };

  users.extraGroups.vboxusers.members = [ "skolem" ];
  users.users.skolem.extraGroups = [ "docker" "adbusers" ];


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
      vim.package = "neovim";
      music.enable = true;
      latex.enable = true;
      irssi.enable = true;
      ssh.enable = true;
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
