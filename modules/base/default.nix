{ config, lib, pkgs, ... }:
let
  hostname = config.custom.base.hostname;
  keys = import ../../ssh-keys.nix;
in
{
  imports = [
    ./tmux
    ./vim
  ];

  options.custom = {
    stateVersion = lib.mkOption {
      example = "21.11";
    };
    base.hostname = lib.mkOption {
      type = lib.types.str;
      example = "mycoolmachine";
    };
  };

  config = {
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      autoOptimiseStore = true;
      gc.automatic = true;
    };

    users = {
      mutableUsers = true;
      users = {
        root = {
          # passwordFile = config.age.secrets."users/root".path;
          openssh.authorizedKeys.keys = [ keys.skolem ];
        };
        skolem = {
          isNormalUser = true;
          extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
          # passwordFile = config.age.secrets."users/skolem".path;
          openssh.authorizedKeys.keys = with keys; [ skolem termux ];
        };
      };
    };

    age.secrets."users/skolem".file = ../../secrets/users/skolem.age;
    age.secrets."users/root".file = ../../secrets/users/root.age;

    console.keyMap = "es";

    boot.cleanTmpDir = true;

    time.timeZone = "Europe/Madrid";
 
    networking = {
      firewall.allowedTCPPorts = [ 22 ];
      hostName = config.custom.base.hostname;
    };

    environment.systemPackages = with pkgs; [
      git
      htop
      killall
      ranger
      rsync
      tree
      unzip
      zip
    ];

   programs = {
      bash = {
        interactiveShellInit = ''
          if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
            tmux attach-session -t ${hostname} || tmux new-session -s ${hostname}
          fi
        '';
        shellAliases = {
          ".." = "cd ..";
          "r" = "ranger";
          "agenix" = "nix run github:ryantm/agenix --"; 
        };
      };
    };

    services = {
      openssh = {
        enable = true;
        passwordAuthentication = false;
      };
    };


    home-manager.useGlobalPkgs = true;

    home-manager.users = {
      skolem = { ... }: {
        home.stateVersion = config.custom.stateVersion;
      };
      root = { ... }: {
        home.stateVersion = config.custom.stateVersion;
      };
    };

    system.stateVersion = config.custom.stateVersion;
  };
}
