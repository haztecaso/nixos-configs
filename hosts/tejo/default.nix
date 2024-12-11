{ config, pkgs, inputs, ... }: {
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 18d";

  users.users.skolem = {
    openssh.authorizedKeys.keys = with config.base.ssh-keys; [
      skolem
      termux
      skolem_deambulante
    ];
    extraGroups = [ "docker" "adbusers" ];
  };

  home-manager.users = {
    root = { ... }: { custom.programs = { tmux.color = "#ee8800"; }; };
    skolem = { ... }: {
      services.syncthing.enable = true;
      services.nextcloud-client.enable = true;
      # programs.autorandr = import ./monitors.nix;
      custom = {
        desktop = {
          enable = true;
          fontSize = 9;
          polybar.bat = "BAT1";
          polybar.mpd = true;
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
          latex.enable = true;
          tmux.color = "#aaee00";
          # music.enable = true;
          vim.config = "latex";
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
    # rustdesk
    android-tools

    # network
    nmap
    dig
    iw
    wirelesstools

    # Chats
    tdesktop
    gajim

    # Mail
    thunderbird

    # Maps
    qgis

    # Browsers
    firefox
    chromium
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
    calibre
    # scantailor-advanced

    # Images
    gimp
    inkscape
    darktable
    unstable.sxiv

    # Video
    unstable.ffmpeg
    vlc
    obs-studio
    kdenlive

    # Audio & music
    audacity
    mixxx
    shortwave

    # 3d
    blender

    # sync
    nextcloud-client

    # money
    unstable.beancount
    unstable.fava

    # Downloads
    soulseekqt
    # transmission-gtk
    transmission_4-gtk
    unstable.yt-dlp
  ];

  virtualisation = {
    docker.enable = true;
  };

  base = {
    hostname = "tejo";
    hostnameSymbol = "𝜏";
    wlp = {
      interface = "wlp0s20f3";
      useDHCP = true;
    };
    eth.interface = "enp0s31f6";
    stateVersion = "24.11";
  };

  environment.extraInit = ''
    xset s 300 300
  '';

  services = {
    safeeyes.enable = true;
    tor.enable = true;
    udev.packages = [ pkgs.android-udev-rules ];
    # ollama = {
    #   enable = true;
    #   package = pkgs.unstable.ollama;
    # };
    # open-webui = {
    #   enable = true;
    #   package = pkgs.unstable.open-webui;
    #   environment.OLLAMA__API_BASE_URL = "http://localhost:11434";
    #   environment.WEBUI_AUTH = "False";
    # };
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

  # fonts.packages = [ pkgs.google-fonts ];

}
