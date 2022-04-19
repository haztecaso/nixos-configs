{ config, lib, pkgs, ... }:
let
  cfg = config.custom.dev;
  pythonPackageNames = lib.attrNames pkgs.python38Packages;
  pythonPackages = map (name: pkgs.python38Packages.${name}) cfg.pythonPackages;
in
{
  options.custom.dev = with lib; {
    enable = mkEnableOption "Custom desktop environment (wm: xmonad)";
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
        ag
        jq
        git
        dust
        ncdu
        python38Full
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
      programs.shells.initExtra = [
        ''
          eval "$(direnv hook bash)"
        ''
      ];
    })
  ];
}
