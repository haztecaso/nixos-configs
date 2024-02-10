{ config, pkgs, inputs, ... }:
{
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 18d";

  users.users.skolem = {
    openssh.authorizedKeys.keys = with config.base.ssh-keys; [ skolem termux ];
    extraGroups = [ "docker" "adbusers" ];
  };

  home-manager.users = {
    root = { ... }: {
      custom.programs = {
        tmux.color = "#eeaa00";
      };
    };
    skolem = { ... }: {
      services.syncthing.enable = true;
      programs.autorandr.profiles = import ./monitors.nix;
      # programs.nushell = {
      #   enable = true;
      #   configFile.source = ./config.nu;
      #   envFile.source = ./env.nu;
      # };
      custom = {
        desktop = {
          enable = true;
          fontSize = 9;
          # polybar.batteryCombined = true; # TODO: arreglar
          polybar.bat = "BAT1";
          polybar.mpd = true;
        };
        shortcuts = {
          paths = {
            N = "~/Nube";
            l = "~/Nube/lecturas";
            mo = "~/Nube/money";
            u = "~/Nube/uni";
            v = "~/vault";
          };
        };
        programs = {
          latex.enable = true;
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
                tex = true;
                typescript = true;
                vimscript = true;
                yaml = true;
              };
            };
            plugins = {
              ack = true;
              commentary = true;
              copilot = true;
              enuch = true;
              fugitive = true;
              gitgutter = true;
              gruvbox = true;
              lastplace = true;
              nix = true;
              repeat = true;
              telescope = true;
              tidal = true;
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

    unstable.logseq
    obsidian

    timewarrior

    # Editors
    unstable.vscodium

    # Identity
    autofirma

    # dev, utils
    redis
    gcc
    pciutils
    unstable.sqlitebrowser
    unstable.docker-compose
    unstable.subfinder
    unstable.file
    unstable.pass
    unstable.axel
    unstable.aria2

    # network
    nmap
    dig
    iw
    wirelesstools

    # Chats
    unstable.tdesktop
    gajim
    # discord

    # Mail
    unstable.thunderbird

    # Maps
    qgis

    # Browsers
    unstable.firefox
    unstable.chromium
    unstable.brave
    unstable.tor-browser-bundle-bin

    # Passwords
    unstable.bitwarden

    # Pdf
    unstable.evince
    unstable.okular
    unstable.pdfarranger

    # Documents, books
    unstable.libreoffice
    unstable.zotero
    unstable.calibre
    # scantailor-advanced

    # Images
    unstable.gimp
    unstable.inkscape
    unstable.darktable
    unstable.sxiv

    # Video
    unstable.ffmpeg
    vlc
    unstable.obs-studio
    unstable.kdenlive

    # Audio & music
    unstable.audacity
    unstable.mixxx
    # tidal
    # superdirt-start

    # 3d
    unstable.blender

    # money
    unstable.beancount
    unstable.fava
    # Downloads
    soulseekqt
    # transmission-gtk
    unstable.transmission_4-gtk
    unstable.yt-dlp
  ];

  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
  };

  base = {
    hostname = "elbrus";
    hostnameSymbol = "ε";
    wlp = { interface = "wlp4s0"; useDHCP = true; };
    eth.interface = "enp0s31f6";
    stateVersion = "23.11";
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
    tor.enable = true;
    teamviewer.enable = true;
  };

  custom = {
    desktop.enable = true;

    services = {
      tailscale.enable = true;
      autofs.enable = true;
    };

    dev = {
      enable = true;
      nodejs = true;
      direnv.enable = true;
    };
  };

  fonts.packages = [ pkgs.google-fonts ];

}
