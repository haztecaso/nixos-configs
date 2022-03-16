{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.nnn;
in
{
  options.custom.programs.ranger = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable custom ranger config with shortcuts";
    };
  };

  config = lib.mkIf cfg.enable (let
    conf = {
      programs.nnn = {
        enable = true;
        package = pkgs.nnn.override ({ withNerdIcons = true; });
        bookmarks = config.custom.shortcuts.paths;
      }
    };
  in {
    home-manager.users.skolem = { ... }: conf;
    home-manager.users.root   = { ... }: conf;
  });
}
