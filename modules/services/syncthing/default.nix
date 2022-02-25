#TODO: Mejorar este modulo para que se pueda usar desde varios hosts
{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services.syncthing;
in
{
  options.custom.services.syncthing = with lib; {
    enable = mkEnableOption "custom vaultwarden service";
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    
      openDefaultPorts = true;
    
      devices = {
        macbook.id = "JE3TRVV-CSMT42I-YUPYLOR-PXKMXSR-GKN3APW-SAHMJRM-JVCX66N-4BBRWQJ";
        realmi8.id = "GGY5ZY5-Y4732SG-2YWHMXT-MZMWT4B-NOVGTUL-RA6ZOIS-7LJNVRB-3M3SEA3";
      };
    
      folders = {
        uni-moodle = {
          devices = [ "macbook" "realmi8" ];
          id = "uni-moodle";
          path = "/var/lib/syncthing/uni-moodle";
        };
        nube = {
          devices = [ "macbook" "realmi8" ];
          id = "default";
          path = "/var/lib/syncthing/nube";
        };
        android-camara = {
          devices = [ "macbook" "realmi8" ];
          id = "rmx3085_fs1b-photos";
          path = "/var/lib/syncthing/android-camara";
        };
      };
    };
  };
}
