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

    users.users.root.openssh.authorizedKeys.keys = [ keys.skolem ];

    home-manager.useGlobalPkgs = true;

    system.stateVersion = config.custom.stateVersion;
  };
}
