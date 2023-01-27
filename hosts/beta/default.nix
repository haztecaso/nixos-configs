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
    skolem = { ... }: {
      home.packages = with pkgs; [
        autofirma
        vscodium
        pdfarranger
        thunderbird
      ];
      custom = {
        #TODO: mail, accounts and filters configs
        # mail = { enable = false; accounts = {}; filters = {}; };
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
          # music.enable = true;
          nnn.bookmarks = {
            N = "~/Nube";
            l = "~/Nube/lecturas";
            u = "~/Nube/uni/Actuales";
          };
          tmux.color = "#aaee00";
          vim.package = pkgs.neovimFull;
        };
      };
     
      services.syncthing.enable = true;
      programs.kitty.enable = true;
      programs.rbw = {
          enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    deploy-rs.deploy-rs
    unstable.yt-dlp
    virt-manager
    docker-compose
    impo
    gparted
    lean3
    darktable
  ];

  virtualisation = {
    virtualbox.host.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
  };

  users.extraGroups.vboxusers.members = [ "skolem" ];
  users.users = {
    skolem.extraGroups = [ "libvirtd" ];
  };

  base = {
    hostname = "beta";
    hostnameSymbol = "β";
    bat = "BAT1";
    wlp = { interface = "wlp3s0"; useDHCP = true; };
    eth.interface = "enp0s31f6";
    stateVersion = "22.11";
  };


  programs = {
    # steam.enable = true; # Deshabilitado temporalmente
    mosh.enable = true;
    dconf.enable = true;
  };

  services = {
    safeeyes.enable = false;
  };

  networking.hosts = {
    "100.71.54.42" = [ "cloud.elvivero.es" ];
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
