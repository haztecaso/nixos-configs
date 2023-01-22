{ config, pkgs, ... }: {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud24;
    appstoreEnable = false;
    hostName = "cloud.elvivero.es";
    # https = true;
    datadir = "/mnt/raid/nextcloud";
    config = {
      adminpassFile = "/mnt/raid/nextcloud-admin-pass";
      defaultPhoneRegion = "ES";
      extraTrustedDomains = ["nas"];
    };
  };
}
