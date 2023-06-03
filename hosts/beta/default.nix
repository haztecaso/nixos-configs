{ config, pkgs, inputs, ... }:
let
  keys = import ../../ssh-keys.nix;
in
{
  imports = [ 
    ./hardware.nix 
    ./monitors.nix 
    ./networking.nix 
  ];

  nix.gc.options = "--delete-older-than 18d";

  users.users.skolem = {
    openssh.authorizedKeys.keys = with config.base.ssh-keys; [ termux skolem_elbrus ];
    extraGroups = [ "libvirtd" "jackaudio" ];
  };

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
        zotero
      ];
      custom = {
        #TODO: mail, accounts and filters configs
        # mail = { enable = false; accounts = {}; filters = {}; };
        desktop = {
          enable = true;
          fontSize = 8;
        };
        shell.aliases = {
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
          vim.package = pkgs.mkNeovim {
            completion.enable = true;
            snippets.enable   = true;
            telescope.enable  = true;
            lsp = {
              enable    = true;
              lightbulb = true;
              languages = {
                bash       = true;
                css        = true;
                docker     = true;
                html       = true;
                json       = true;
                python     = true;
                typescript = true;
                yaml       = true;
              };
            };
            plugins = {
              tidal = true;
            };
          };
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
    unstable.yt-dlp
    virt-manager
    docker-compose
    # impo
    gparted
    unstable.lean3
    darktable
    qjackctl
    tidal
    superdirt-start
    mixxx
    ffmpeg
    openai-whisper-cpp
    # qgis
    # python39Packages.pyqt5
  ];


  virtualisation = {
    virtualbox.host.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
  };

  users.extraGroups.vboxusers.members = [ "skolem" ];

  base = {
    hostname = "beta";
    hostnameSymbol = "β";
    bat = "BAT1";
    wlp = { interface = "wlp3s0"; useDHCP = true; };
    eth.interface = "enp0s31f6";
    stateVersion = "23.05";
  };


  programs = {
    # steam.enable = true; # Deshabilitado temporalmente
    mosh.enable = true;
    dconf.enable = true;
  };

  # boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
  # hardware = {
  #   pulseaudio.package = pkgs.pulseaudio.override { jackaudioSupport = true; };
  # };
  # services.jack.jackd.enable = true;

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
      direnv.enable = true;
    };
  };

  services.rpcbind.enable = true;

}
