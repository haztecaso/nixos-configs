{ pkgs, ... }: {
  services = {
    syncthing = {
      enable = true;
      devices = {
        macbook.id = "JE3TRVV-CSMT42I-YUPYLOR-PXKMXSR-GKN3APW-SAHMJRM-JVCX66N-4BBRWQJ";
        realmi8.id = "GGY5ZY5-Y4732SG-2YWHMXT-MZMWT4B-NOVGTUL-RA6ZOIS-7LJNVRB-3M3SEA3";
      };
      extraOptions = {
        gui.theme = "dark";
      };
      guiAddress = "127.0.0.1:8384";
      openDefaultPorts = true;
    };
  };
}
