{ config, lib, pkgs, ... }:
let
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

    users.users = {
      root = {
        passwordFile = config.age.secrets."passwords/users/root".file;
        openssh.authorizedKeys.keys = [ keys.skolem ];
      }
      skolem = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        passwordFile = config.age.secrets."passwords/users/skolem".file;
        openssh.authorizedKeys.keys = with keys; [ skolem termux ];
      };
    };

    age.secrets."passwords/users/skolem".file = ../../secrets/passwords/users/skolem.age;
    age.secrets."passwords/users/root".file = ../../secrets/passwords/users/root.age;

    environment.systemPackages = with pkgs; [
      git
      ranger
      rsync
    ];
 
    programs = {
      bash = {
        shellAliases = {
          ".." = "cd ..";
          "r" = "ranger";
          "agenix" = "nix run github:ryantm/agenix --"; 
        };
      };
    };

    boot.cleanTmpDir = true;

    time.timeZone = "Europe/Madrid";


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
