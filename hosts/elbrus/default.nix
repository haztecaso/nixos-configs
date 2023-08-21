{ config, pkgs, inputs, ... }:
{
  imports = [ ./hardware.nix ./monitors.nix ];

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
      home.packages = with pkgs; [
        autofirma
        logseq
        obsidian
        pdfarranger
        thunderbird
        timewarrior
        unstable.yt-dlp
        vscodium
        zotero
      ];
      services.syncthing.enable = true;
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
          };
        };
        programs = {
          latex.enable = true;
          money.enable = true;
          tmux.color = "#aaee00";
          vim.package = pkgs.neovimDefault;
        };
        shell.aliases = {
          python = "${pkgs.python38Packages.ipython}/bin/ipython";
          youtube-dl = "yt-dlp";
          ytdl = "yt-dlp";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    sqlitebrowser
    redis
    darktable
    qgis
    gparted
    parted
    mixxx
    ffmpeg
    openai-whisper-cpp
  ];

  virtualisation = {
    docker.enable = true;
  };

  base = {
    hostname = "elbrus";
    hostnameSymbol = "ε";
    bat = "BAT1";
    wlp = { interface = "wlp4s0"; useDHCP = true; };
    eth.interface = "enp0s31f6";
    stateVersion = "23.05";
  };

  environment.extraInit = ''
    xset s 300 300
  '';

  programs = {
    mosh.enable = true;
    dconf.enable = true;
  };

  services = {
    safeeyes.enable = true;
    printing.drivers = [
      (pkgs.writeTextDir "share/cups/model/ricoh-mp-c2011-pdf.ppd" (builtins.readFile ./Ricoh-MP_C2011-PDF-Ricoh.ppd))
    ];

    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
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

  fonts.fonts = [ pkgs.google-fonts ];

}
