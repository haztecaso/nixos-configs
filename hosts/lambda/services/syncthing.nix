{ pkgs, ... }: {
  services = {
    syncthing = {
      enable = true;

      extraOptions.gui.enabled = false;
      openDefaultPorts = true;

      devices = {
        macbook.id = "JE3TRVV-CSMT42I-YUPYLOR-PXKMXSR-GKN3APW-SAHMJRM-JVCX66N-4BBRWQJ";
        realmi8.id = "GGY5ZY5-Y4732SG-2YWHMXT-MZMWT4B-NOVGTUL-RA6ZOIS-7LJNVRB-3M3SEA3";
      };

      folders = {
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
