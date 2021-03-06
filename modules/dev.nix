{ config, lib, pkgs, ... }:
let
  cfg = config.custom.dev;
  pythonPackageNames = lib.attrNames pkgs.python38Packages;
  pythonPackages = map (name: pkgs.python38Packages.${name}) cfg.pythonPackages;
in
{
  options.custom.dev = with lib; {
    enable = mkEnableOption "Enable dev module";
    pythonPackages = mkOption {
      # type = types.enum pythonPackageNames; #TODO: fix
      default = [ ];
      description = "Set of python packages to install globally";
    };
    direnv = {
      enable = mkEnableOption "direnv support";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        wget
        axel
        python38
        silver-searcher
        jq
        git
        du-dust
        ncdu
        python38Full
        filezilla
      ] ++ pythonPackages;
    })
    (lib.mkIf cfg.direnv.enable {
      # nix-direnv flake support
      nixpkgs.overlays = [
        (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; })
      ];
      environment.systemPackages = with pkgs; [ direnv nix-direnv ];
      # nix options for derivations to persist garbage collection
      nix.extraOptions = ''
        keep-outputs = true
        keep-derivations = true
      '';
      environment.pathsToLink = [ "/share/nix-direnv" ];

      # shell hook
      home-manager.sharedModules = [{
        custom.shell.initExtra = [
          ''
            eval "$(direnv hook bash)"
          ''
        ];
      }];
    })
  ];
}
