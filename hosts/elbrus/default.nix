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

    logseq
    obsidian

    timewarrior

    # Editors
    vscodium

    # Identity
    autofirma

    # dev, utils
    redis
    sqlitebrowser
    docker-compose
    subfinder
    gcc
    file
    pass
    axel
    aria2
    pciutils

    # network
    nmap
    dig
    iw
    wirelesstools

    # Chats
    unstable.tdesktop
    # discord

    # Mail
    thunderbird

    # Maps
    qgis

    # Browsers
    firefox
    chromium
    brave
    unstable.tor-browser-bundle-bin

    # Passwords
    bitwarden

    # Pdf
    evince
    okular
    pdfarranger

    # Documents, books
    libreoffice
    zotero
    # calibre
    # scantailor-advanced

    # Images
    gimp
    inkscape
    darktable
    sxiv

    # Video
    ffmpeg
    vlc
    obs-studio
    kdenlive

    # Audio & music
    audacity
    mixxx
    # tidal
    # superdirt-start

    # 3d
    blender

    # money
    beancount
    fava
    # Downloads
    soulseekqt
    transmission-gtk
    unstable.yt-dlp
  ];

  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
  };

  base = {
    hostname = "elbrus";
    hostnameSymbol = "ε";
    bat = "BAT1";
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
