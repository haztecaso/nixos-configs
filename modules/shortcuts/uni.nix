{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.shortcuts.uni;
in
  {
    options.shortcuts.uni = with lib; {
      enable = mkEnableOption "Uni shortcuts";
      path = mkOption {
        type = types.str;
        default = "~/Nube/uni/Actuales/";
        description = "Carpeta de asignaturas actuales";
      };
      asignaturas = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Asignaturas actuales";
      };
    };
    config = lib.mkIf cfg.enable {
      programs.shells.aliases = lib.genAttrs cfg.asignaturas (
        a: "cd ${cfg.path}${a}"
      );
    };
  }
