{ config, pkgs, ... }:
let
  keys = import ../../ssh-keys.nix;
in
{
  imports = [ ./hardware.nix ./monitors.nix ];

  nix.gc.options = "--delete-older-than 18d";


  home-manager.users = {
    root = { ... }: {
      custom.programs = {
        tmux.color = "#eeaa00";
        vim.package = pkgs.neovimFull;
      };
    };
    jam = { ... }: {
      home.packages = with pkgs; [
        audacity
        puredata
        vlc
      ];
      custom = {
        desktop = {
          enable = true;
          fontSize = 9;
          theme = "light";
          polybar.enable = false;
        };
      };
    };
    skolem = { ... }: {
      home.packages = with pkgs; [ autofirma ];
      custom = {
        #TODO: mail, accounts and filters configs
        # mail = {
        #   enable = false;
        #   accounts = {};
        #   filters = {};
        # };
        desktop = {
          enable = true;
          fontSize = 8;
        };
        programs = {
          irssi.enable = true;
          latex.enable = true;
          money.enable = true;
          music = {
            enable = true;
            dir = /home/skolem/Music/Library;
          };
          nnn.bookmarks = {
            N = "~/Nube";
            l = "~/Nube/lecturas";
            m = "~/Music";
            p = "~/Pictures";
            s = "~/src";
            u = "~/Nube/uni/Actuales";
            v = "~/Videos";
          };
          tmux.color = "#aaee00";
          vim.package = pkgs.neovimFull;
        };
      };
     
      services.syncthing.enable = true;
      programs.kitty.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    unstable.yt-dlp
    virt-manager
  ];

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  users.users = {
    skolem.extraGroups = [ "libvirtd" ];
  };

  base = {
    hostname = "beta";
    hostnameSymbol = "β";
    bat = "BAT1";
    wlp = { interface = "wlp3s0"; useDHCP = true; };
    eth.interface = "enp0s31f6";
    stateVersion = "22.05";
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

  programs = {
    shells.aliases = {
      ytdl = "yt-dlp";
      youtube-dl = "yt-dlp";
      python = "${pkgs.python38Packages.ipython}/bin/ipython";
    };
    steam.enable = true;
    mosh.enable = true;
    dconf.enable = true;
  };

  services.safeeyes.enable = true;

  custom = {
    desktop.enable = true;
    programs = {
      ranger.enable = false;
    };

    services = {
      tailscale.enable = true;
    };

    dev = {
      enable = true;
      # pythonPackages = [ "numpy" "matplotlib" "ipython" ];
      direnv.enable = true;
    };
  };

}
