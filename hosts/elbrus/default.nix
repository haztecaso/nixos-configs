{ config, pkgs, inputs, ... }:
{
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 18d";

  users.users.skolem = {
    openssh.authorizedKeys.keys = with config.base.ssh-keys; [ skolem termux viaje24 skolem_deambulante ];
    extraGroups = [ "docker" "adbusers" ];
  };

  home-manager.users = {
    root = { ... }: {
      custom.programs = {
        tmux.color = "#ee8800";
      };
    };
    skolem = { ... }: {
      services.syncthing.enable = true;
      services.nextcloud-client.enable = true;
      programs.autorandr = import ./monitors.nix;
      # programs.nushell = {
      #   enable = true;
      #   configFile.source = ./config.nu;
      #   envFile.source = ./env.nu;
      # };
      home.packages = [ pkgs.klog-time-tracker ];
      programs.zsh.initExtra = ''
        source <(klog completion -c zsh)
      '';
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
          vim.defaultConfig = "full";
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
    rustdesk
    android-tools

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
    audacity
    mixxx
    # tidal
    # superdirt-start

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
    adb.enable = true;
  };

  services = {
    safeeyes.enable = true;
    tor.enable = true;
    teamviewer.enable = true;
    udev.packages = [ pkgs.android-udev-rules ];
    printing.drivers = [
      (pkgs.writeTextDir "share/cups/model/ricoh-mp-c2011-pdf.ppd" (builtins.readFile ./Ricoh-MP_C2011-PDF-Ricoh.ppd))
    ];
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
