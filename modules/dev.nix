{ config, lib, pkgs, ... }:
let
  cfg = config.custom.dev;
  pythonPackageNames = lib.attrNames pkgs.python38Packages;
  pythonPackages = map (name: pkgs.python310Packages.${name}) cfg.pythonPackages;
in
{
  options.custom.dev = with lib; {
    enable = mkEnableOption "Enable dev module";
    pythonPackages = mkOption {
      # type = types.enum pythonPackageNames; #TODO: fix
      default = [ ];
      description = "Set of python packages to install globally";
    };
    nodejs = mkEnableOption "Enable nodejs dev packages and configs";
    direnv = {
      enable = mkEnableOption "direnv support";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        poetry
        wget
        axel
        silver-searcher
        jq
        git
        du-dust
        ncdu
        python3Full
        filezilla
        bat
        eza
        fd
        ripgrep
      ] ++ pythonPackages;
    })
    (lib.mkIf cfg.nodejs {
      environment.systemPackages = with pkgs; [ nodejs yarn nodePackages.pnpm ];
    })
    (lib.mkIf cfg.direnv.enable {
      # TODO: remove old config
      # nix-direnv flake support
      # nixpkgs.overlays = [
      #   (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; })
      # ];
      # environment.systemPackages = with pkgs; [ direnv nix-direnv ];
      # environment.pathsToLink = [ "/share/nix-direnv" ];
      programs.direnv = {
        enable = true;
        silent = false;
        loadInNixShell = true;
        nix-direnv.enable = true;
      };
      # TODO: understand implications of this config
      # nix options for derivations to persist garbage collection
      nix.extraOptions = ''
        keep-outputs = true
        keep-derivations = true
      '';
    })
  ];
}
