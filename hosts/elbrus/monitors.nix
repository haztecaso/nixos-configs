{ config, pkgs, ... }:
let
  eDP = "00ffffffffffff000daec3140000000026190104951f1178027e45935553942823505400000001010101010101010101010101010101da1d56e250002030442d470035ad10000018000000fe004e3134304247412d4541330a20000000fe00434d4e0a202020202020202020000000fe004e3134304247412d4541330a200053";
  HDMI = "00ffffffffffff004c2de9094a57595a1a18010380341d782a7dd1a45650a1280f5054bfef80714f81c0810081809500a9c0b3000101023a801871382d40582c450009252100001e011d007251d01e206e28550009252100001e000000fd00324b1e5111000a202020202020000000fc00533234433635300a202020202001bd02031af14690041f131203230907078301000066030c00100080011d00bc52d01e20b828554009252100001e8c0ad090204031200c4055000925210000188c0ad08a20e02d10103e96000925210000180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c9";
in
{
  custom.monitors = {
    profiles = {
      onlysmall = {
        fingerprint.eDP-1 = eDP;
        config = {
          eDP-1 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1366x768";
            rate = "59.99";
          };
        };
      };
      both = {
        fingerprint = {
          HDMI-2 = HDMI;
          eDP-1 = eDP;
        };
        config = {
          HDMI-2 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "2560x1440";
            rate = "59.95";
          };
          eDP-1 = {
            enable = true;
            crtc = 1;
            primary = false;
            position = "2560x0";
            mode = "1366x768";
            rate = "59.99";
          };
        };
      };
    };
    defaultTarget = "onlysmall";
  };
}
