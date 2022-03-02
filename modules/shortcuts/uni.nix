{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.custom.shortcuts.uni;
in
  {
    options.custom.shortcuts.uni = with lib; {
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
    config = lib.mkIf cfg.enable = {
      custom.shells.aliases = lib.genAttrs cfg.asignaturas (a: "${cfg.path}${a}");
    };
  }
