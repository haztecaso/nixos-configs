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
      home.packages = with pkgs; [ autofirma ];
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
          tmux.color = "#aaee00";
          vim.package = pkgs.neovimFull;
        };
      };
    };
  };

  virtualisation = {
    docker.enable = true;
  };

  base = {
    hostname = "elbrus";
    hostnameSymbol = "ε";
    bat = "BAT1";
    wlp = { interface = "wlp4s0"; useDHCP = true; };
    eth.interface = "enp0s31f6";
    stateVersion = "22.05";
  };


  programs = {
    mosh.enable = true;
    dconf.enable = true;
  };

  services = {
    safeeyes.enable = false;
  };

  custom = {
    desktop.enable = true;

    dev = {
      enable = true;
      # pythonPackages = [ "numpy" "matplotlib" "ipython" ];
      direnv.enable = true;
    };
  };

}
