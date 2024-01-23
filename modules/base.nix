{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.base;
  nixpkgsPath = "/etc/nixpkgs/channels/nixpkgs";
  unstablePath = "/etc/nixpkgs/channels/unstable";
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
    ssh-keys = mkOption {
      type = types.attrsOf types.str;
      description = "Public ssh keys";
      readOnly = true;
    };
  };

  config = lib.mkMerge [
    {
      nix =
        {
          package = pkgs.nixFlakes;
          extraOptions = ''
            experimental-features = nix-command flakes
          '';
          settings = {
            keep-derivations = true;
            auto-optimise-store = true;
            substituters = [
              "http://nas:5555"
              "https://cache.nixos.org"
            ];
            trusted-public-keys = [
              "nas:TngeLMrJNW+7qgP4hMFsrtuqFMD434NGOoYLp+twews="
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            ];
          };
          # binaryCachePublicKeys = [ "lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk=" ];
          gc.automatic = true;

          registry = {
            nixpkgs.flake = inputs.nixpkgs;
            unstable.flake = inputs.unstable;
          };

          nixPath = [
            "nixpkgs=${nixpkgsPath}"
            "unstable=${unstablePath}"
            # "/nix/var/nix/profiles/per-user/root/channels"
          ];
        };

      systemd.tmpfiles.rules = [
        "L+ ${nixpkgsPath}     - - - - ${inputs.nixpkgs}"
        "L+ ${unstablePath}     - - - - ${inputs.unstable}"
      ];


      base.ssh-keys = import ../ssh-keys.nix;

      users = {
        mutableUsers = true;
        defaultUserShell = pkgs.zsh;
        users = {
          root = {
            # passwordFile = config.age.secrets."users/root".path;
            # openssh.authorizedKeys.keys = [ keys.skolem ];
          };
          skolem = {
            isNormalUser = true;
            extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
            # passwordFile = config.age.secrets."users/skolem".path;
            # openssh.authorizedKeys.keys = with keys; [ skolem ];
          };
        };
      };

      # age.secrets."users/skolem".file = ../secrets/users/skolem.age;
      # age.secrets."users/root".file = ../secrets/users/root.age;

      console.keyMap = "es";

      boot.tmp.cleanOnBoot = true;

      time.timeZone = "Europe/Madrid";

      networking = {
        firewall.allowedTCPPorts = [ 22 ];
        hostName = cfg.hostname;
      };

      environment = {
        systemPackages = with pkgs; [
          git
          htop
          killall
          rsync
          tree
          unzip
          zip
          silver-searcher
          ripgrep
        ];
        shells = with pkgs; [ bashInteractive zsh fish ];
        # Copied from comment in https://www.reddit.com/r/NixOS/comments/19595vc/how_to_keep_source_when_doing_garbage_collection
        # this should help avoid flake dependencies being garbage collected
        etc = builtins.listToAttrs (builtins.map
          (input:
            lib.attrsets.nameValuePair "sources/${input}" {
              enable = true;
              source = inputs.${input};
              mode = "symlink";
            })
          (builtins.attrNames inputs));
      };

      programs.zsh.enable = true;

      services = {
        openssh = {
          enable = true;
          settings.PasswordAuthentication = false;
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
