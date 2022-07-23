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
      example = "~/Nube/uni/Actuales/";
      description = "Carpeta de asignaturas actuales";
    };
    asignaturas = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Asignaturas actuales";
    };
  };
  config = lib.mkIf cfg.enable {
    custom.shell.aliases = lib.genAttrs cfg.asignaturas (
      a: "cd ${cfg.path}${a}"
    );
  };
}
