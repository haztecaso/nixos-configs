{ config, lib, pkgs, ... }:
let cfg = config.custom.dev;
in {
  options.custom.dev = with lib; {
    enable = mkEnableOption "Enable dev module";
    nodejs = mkEnableOption "Enable nodejs dev packages and configs";
    direnv = { enable = mkEnableOption "direnv support"; };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        axel
        bat
        docker-compose
        du-dust
        eza
        fd
        filezilla
        git
        gnumake
        jq
        lazygit
        ncdu
        poetry
        python3Full
        redis
        ripgrep
        silver-searcher
        sqlitebrowser
        subfinder
        wget
      ];
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
