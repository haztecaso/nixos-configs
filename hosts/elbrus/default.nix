{ config, pkgs, inputs, ... }:
{
  imports = [ ./hardware.nix ./monitors.nix ];

  nix.gc.options = "--delete-older-than 18d";

  home-manager.users = {
    root = { ... }: {
      custom.programs = {
        tmux.color = "#eeaa00";
        vim.package = pkgs.neovimBase;
      };
    };
    skolem = { ... }: {
      home.packages = with pkgs; [ autofirma thunderbird ];
      custom = {
        desktop = {
          enable = true;
          fontSize = 8;
        };
        shell.aliases = {
          deploy = "deploy -k";
        };
        shortcuts = {
          paths = {
            sr = "~/src";
          };
        };
        programs = {
          nnn.bookmarks = {
            s = "~/src";
          };
          latex.enable = true;
          tmux.color = "#aaee00";
          vim.package = pkgs.neovimWebDev;
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    sqlitebrowser
    redis
    scantailor-advanced
  ];

  virtualisation = {
    docker.enable = true;
  };

  users.users = {
    skolem.extraGroups = [ "docker" "adbusers" ];
  };

  base = {
    hostname = "elbrus";
    hostnameSymbol = "ε";
    bat = "BAT1";
    wlp = { interface = "wlp4s0"; useDHCP = true; };
    eth.interface = "enp0s31f6";
    stateVersion = "22.11";
  };


  programs = {
    mosh.enable = true;
    dconf.enable = true;
  };

  services = {
    safeeyes.enable = true;
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
      pythonPackages = [ "poetry" ];
      direnv.enable = true;
    };
  };
  networking.firewall = {
    allowedTCPPorts = [ 80 ];
  };


}
