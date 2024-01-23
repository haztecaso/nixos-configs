{ config, lib, pkgs, ... }:
let
  cfg = config.custom.dev;
in
{
  options.custom.dev = with lib; {
    enable = mkEnableOption "Enable dev module";
    nodejs = mkEnableOption "Enable nodejs dev packages and configs";
    python = mkEnableOption "Enable python dev packages and configs";
    direnv = mkEnableOption "direnv support";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
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
        redis
        sqlitebrowser
        docker-compose
        subfinder
      ];
    })
    (lib.mkIf cfg.nodejs {
      environment.systemPackages = with pkgs; [ nodejs yarn nodePackages.pnpm ];
    })
    (lib.mkIf cfg.python {
      environment.systemPackages = with pkgs; [ poetry ];
    })
    (lib.mkIf cfg.direnv {
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
    })
  ];
}
