{ config, lib, pkgs, ... }:
let
  keys = import ../../ssh-keys.nix;
  cfg = config.custom.base;
in
{
  options.custom = with lib;{
    stateVersion = mkOption {
      example = "21.11";
    };
    base = {
      hostname = mkOption {
        type = types.str;
        example = "mycoolmachine";
      };
      hostnameSymbol = mkOption {
        type = types.str;
        default = cfg.hostname;
      };
      wlp = {
        interface = mkOption {
          type = types.str;
          default = "";
          example = "wlp1s0";
        };
        useDHCP = mkEnableOption "enable dhcp for the wifi interface";
      };
      eth = {
        interface = mkOption {
          type = types.str;
          default = "";
          example = "enp1s0";
        };
        useDHCP = mkEnableOption "enable dhcp for the eth interface";
      };
    };
  };

  config = lib.mkMerge [
    {
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
    }

    (lib.mkIf cfg.wlp.useDHCP {
      networking.interfaces.${cfg.wlp.interface}.useDHCP = true;
    })

    (lib.mkIf cfg.eth.useDHCP {
      networking.interfaces.${cfg.eth.interface}.useDHCP = true;
    })
  ];
}
