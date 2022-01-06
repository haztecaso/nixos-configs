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

    users.users.skolem = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      hashedPassword = "$6$IzsxtbrC5H9XoQTb$5pmicFaRBUfPSg26KSFV1B7ije86dszUM27gy9LF5ElgQLH/rl9GG5kyHnG.Co2vZ6LoGzZl7cJ8ZklzWnxjo1";    
      openssh.authorizedKeys.keys = with keys; [ skolem termux ];
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
