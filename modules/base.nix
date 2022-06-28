{ config, lib, pkgs, ... }:
let
  keys = import ../ssh-keys.nix;
  cfg = config.base;
in
{
  options.base = with lib;{
    stateVersion = mkOption {
      example = "21.11";
      description = "stateVersion for nixos and home-manager configs";
    };
    hostname = mkOption {
      type = types.str;
      example = "mycoolmachine";
      description = "hostname of the machine";
    };
    hostnameSymbol = mkOption {
      type = types.str;
      default = cfg.hostname;
      description = "hostname symbol of the machine. For shells and other programs.";
    };
    bat = mkOption {
      type = types.str;
      example = "BAT0";
      description = "Battery device name";
    };
    wlp = {
      interface = mkOption {
        type = types.str;
        default = "";
        example = "wlp1s0";
        description = "wifi interface";
      };
      useDHCP = mkEnableOption "enable dhcp for the wifi interface";
    };
    eth = {
      interface = mkOption {
        type = types.str;
        default = "";
        example = "enp1s0";
        description = "ethernet interface";
      };
      useDHCP = mkEnableOption "enable dhcp for the eth interface";
    };
    sound = mkEnableOption "Wether to enable sound support (with pulseaudio).";
    printing = mkEnableOption "Wether to enable printing support (installing drivers).";
  };

  config = lib.mkMerge [
    {
      nix = {
        package = pkgs.nixFlakes;
        extraOptions = ''
          experimental-features = nix-command flakes
          # trusted-substituters = https://lean4.cachix.org/
        '';
        autoOptimiseStore = true;
        # binaryCachePublicKeys = [ "lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk=" ];
        gc.automatic = true;
      };

      nixpkgs.config.allowUnfree = true;

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

      age.secrets."users/skolem".file = ../secrets/users/skolem.age;
      age.secrets."users/root".file = ../secrets/users/root.age;

      console.keyMap = "es";

      boot.cleanTmpDir = true;

      time.timeZone = "Europe/Madrid";

      networking = {
        firewall.allowedTCPPorts = [ 22 ];
        hostName = cfg.hostname;
      };

      environment.systemPackages = with pkgs; [
        git
        htop
        killall
        rsync
        tree
        unzip
        zip
      ];

      services = {
        openssh = {
          enable = true;
          passwordAuthentication = false;
        };
      };

      system.stateVersion = config.base.stateVersion;
    }

    (lib.mkIf cfg.wlp.useDHCP {
      networking.interfaces.${cfg.wlp.interface}.useDHCP = true;
    })

    (lib.mkIf cfg.eth.useDHCP {
      networking.interfaces.${cfg.eth.interface}.useDHCP = true;
    })

    (lib.mkIf cfg.sound {
      sound.enable = true; # Enable sound.
      
      hardware = {
        pulseaudio = {
          enable = true;
           # Needed by mpd to be able to use Pulseaudio
          extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
        };
      };
    })
    (lib.mkIf cfg.printing {
      services.printing = {
        enable = true;
        drivers = [ pkgs.hplip ];
      };
    })
  ];
}
