{ config, pkgs, ... }: {
  imports = [ ./hardware.nix ];

  base = {
    hostname = "posets";
    hostnameSymbol = "π";
    wlp = {
      interface = "wlp2s0";
      useDHCP = true;
    };
    eth.interface = "enp0s31f6";
    stateVersion = "23.11";
  };

  nix.gc.options = "--delete-older-than 18d";

  users.users.skolem = {
    openssh.authorizedKeys.keys = with config.base.ssh-keys; [
      viaje24
      skolem_elbrus
      termux
    ];
    extraGroups = [ "docker" "adbusers" ];
  };

  home-manager.users = {
    skolem = { ... }: {
      services.syncthing.enable = true;
      services.nextcloud-client.enable = true;
      custom = {
        desktop = {
          enable = true;
          fontSize = 9;
          polybar.fontSize = 18;
          polybar.bat = "BAT0";
          # polybar.mpd = true;
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
          vim.defaultConfig = "full";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # openai-whisper-cpp
    rofi-calc # todo: move to home module
    rofi-rbw # todo: move to home module

    filezilla
    gparted
    parted

    logseq
    obsidian

    # autofirma

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

    # network
    nmap
    dig
    iw
    wirelesstools

    # Chats
    unstable.tdesktop

    # Mail
    unstable.thunderbird

    # Maps
    qgis

    # Browsers
    unstable.firefox
    unstable.chromium
    unstable.tor-browser-bundle-bin

    # Passwords
    bitwarden

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

    # sync
    nextcloud-client

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

  services.xserver.dpi = 180;
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_SCALE_FACTOR = "2";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  fonts.packages = [ pkgs.google-fonts ];
}
