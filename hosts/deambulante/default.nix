{ config, pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  base = {
    hostname = "deambulante";
    hostnameSymbol = "δ";
    wlp = { interface = "wlp3s0"; useDHCP = true; };
    eth.interface = "enp0s31f6";
    stateVersion = "23.11";
  };

  nix.gc.options = "--delete-older-than 18d";

  users.users.skolem = {
    openssh.authorizedKeys.keys = with config.base.ssh-keys; [ viaje24 skolem_elbrus termux ];
    extraGroups = [ "docker" "adbusers" "dialout" ];
  };

  home-manager.users = {
    root = { ... }: {
      custom.programs = {
        tmux.color = "#eeaa00";
      };
    };
    skolem = { ... }: {
      services.syncthing.enable = true;
      services.nextcloud-client.enable = true;
      custom = {
        desktop = {
          enable = true;
          fontSize = 9;
          # polybar.batteryCombined = true; # TODO: arreglar
          polybar.bat = "BAT1";
        };
        shortcuts = {
          paths = {
            N = "~/Nextcloud";
            l = "~/Nextcloud/lecturas";
            mo = "~/Nube/money";
            u = "~/Nextcloud/uni";
            v = "~/vault";
          };
        };
        programs = {
          tmux.color = "#aaee00";
          # music.enable = true;
          # TODO: reenable custom vim package
          vim.package = pkgs.mkNeovim {
            completion.enable = true;
            snippets.enable = true;
            lsp = {
              enable = true;
              languages = {
                bash = true;
                clang = true;
                css = true;
                docker = true;
                html = true;
                json = true;
                lean = false;
                lua = true;
                nix = true;
                php = true;
                python = true;
                tex = false;
                typescript = true;
                vimscript = true;
                yaml = true;
              };
            };
            plugins = {
              ack = true;
              commentary = true;
              copilot = false;
              enuch = true;
              fugitive = true;
              gitgutter = true;
              gruvbox = true;
              lastplace = true;
              nix = true;
              repeat = true;
              telescope = true;
              tidal = false;
              toggleterm = true;
              treesitter = true;
              vim-airline = true;
              vim-visual-multi = true;
              vimtex = true;
              vinegar = true;
            };
          };
        };
        shell.aliases = {
          python = "${pkgs.python3Packages.ipython}/bin/ipython";
          youtube-dl = "yt-dlp";
          ytdl = "yt-dlp";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # openai-whisper-cpp
    rofi-calc # todo: move to home module
    rofi-rbw # todo: move to home module

    # Partitions
    filezilla
    gparted
    parted

    logseq
    obsidian
    klog-time-tracker

    # Identity
    autofirma

    # dev, utils
    gcc
    pciutils
    unstable.sqlitebrowser
    unstable.docker-compose
    unstable.subfinder
    unstable.file
    unstable.pass
    unstable.axel
    unstable.aria2
    rustdesk

    # network
    nmap
    dig
    iw
    wirelesstools

    # Chats
    unstable.tdesktop
    gajim

    # Mail
    unstable.thunderbird

    # Maps
    qgis

    # Browsers
    unstable.firefox
    unstable.chromium
    unstable.tor-browser-bundle-bin

    # Passwords
    unstable.bitwarden

    # Pdf
    unstable.evince
    unstable.okular
    unstable.pdfarranger

    # Documents, books
    unstable.libreoffice
    unstable.calibre

    # Images
    unstable.gimp
    unstable.inkscape
    unstable.darktable
    unstable.sxiv

    # Video
    unstable.ffmpeg
    vlc
    unstable.kdenlive

    # Audio & music
    unstable.audacity
    unstable.mixxx

    # sync
    nextcloud-client

    # money
    unstable.beancount
    unstable.fava

    # Downloads
    soulseekqt
    unstable.transmission_4-gtk
    unstable.yt-dlp
  ];

  virtualisation = {
    docker.enable = true;
  };



  environment.extraInit = ''
    xset s 300 300
  '';

  programs = {
    mosh.enable = true;
    dconf.enable = true;
    adb.enable = true;
  };

  services = {
    safeeyes.enable = true;
  };

  custom = {
    desktop.enable = true;

    services = {
      tailscale.enable = true;
    };

    dev = {
      enable = true;
      nodejs = true;
      direnv.enable = true;
    };
  };

  fonts.packages = [ pkgs.google-fonts ];

}
