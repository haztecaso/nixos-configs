#TODO: Mejorar este modulo para que se pueda usar desde varios hosts
{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services.syncthing;
  devices = {
    macbook.id = "JE3TRVV-CSMT42I-YUPYLOR-PXKMXSR-GKN3APW-SAHMJRM-JVCX66N-4BBRWQJ";
    realmi8.id = "GGY5ZY5-Y4732SG-2YWHMXT-MZMWT4B-NOVGTUL-RA6ZOIS-7LJNVRB-3M3SEA3";
    beta.id = "35S5L2L-GQPOM5V-VDK76HQ-DT6FRZJ-ZYIXL36-JYONUE7-M5C33T7-KAS76AK";
    elbrus.id = "45G57QE-RJX2RHF-HIBZ46W-IMMKIMM-LVA2EJB-YYWX2A4-XDQDSRK-4TOT3QM";
  };
  folders = {
    uni-moodle = {
      devices = [ "beta" "macbook" "realmi8" ];
      id = "uni-moodle";
      path = "/var/lib/syncthing/uni-moodle";
    };
    nube = {
      devices = [ "beta" "macbook" "realmi8" ];
      id = "default";
      path = "/var/lib/syncthing/nube";
    };
    vault = {
      devices = [ "beta" "elbrus" "macbook" "realmi8" ];
      id = "default";
      path = "/var/lib/syncthing/vault";
    };
    android-camara = {
      devices = [ "macbook" "realmi8" ];
      id = "rmx3085_fs1b-photos";
      path = "/var/lib/syncthing/android-camara";
    };
  };
in
{
  options.custom.services.syncthing = with lib; {
    enable = mkEnableOption "custom syncthing service";
    folders = mkOption {
      type = types.listOf (types.enum (builtins.attrNames folders));
      default = [ ];
      description = "Folders to sync";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      inherit devices;
      folders = lib.getAttrs cfg.folders folders;
      openDefaultPorts = true;
    };
  };
}
