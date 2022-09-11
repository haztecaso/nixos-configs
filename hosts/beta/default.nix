{ config, pkgs, inputs, ... }:
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
      home.packages = with pkgs; [ autofirma vscodium ];
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
        shell.aliases = {
          deploy = "deploy -k";
          python = "${pkgs.python38Packages.ipython}/bin/ipython";
          youtube-dl = "yt-dlp";
          ytdl = "yt-dlp";
        };
        shortcuts = {
          paths = {
            N = "~/Nube";
            l = "~/Nube/lecturas";
            mo = "~/Nube/money";
            sr = "~/src";
            u = "~/Nube/uni/Actuales";
          };
          uni = {
            enable = true;
            path = "~/Nube/uni/Actuales/";
          };
        };
        programs = {
          irssi.enable = true;
          latex.enable = true;
          money.enable = true;
          music = {
            enable = true;
            client.enable = true;
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
    deploy-rs.deploy-rs
    unstable.yt-dlp
    virt-manager
    docker-compose
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


  programs = {
    steam.enable = true;
    mosh.enable = true;
    dconf.enable = true;
  };

  services = {
    safeeyes.enable = false;
  };

  custom = {
    desktop.enable = true;

    services = {
      tailscale.enable = true;
      autofs.enable = true;
    };

    dev = {
      enable = true;
      pythonPackages = [ "poetry" ];
      direnv.enable = true;
    };
  };

  services.rpcbind.enable = true;

}
