{ config, pkgs, lib, ... }: 
{
  # age.secrets."cloudflare".file = ../../secrets/cloudflare.age;
  security.acme = {
    acceptTerms = true;
    defaults.email = "adrianlattes@disroot.org";
    # certs."elvivero.es" = {
    #   dnsProvider = "cloudflare";
    #   credentialsFile = config.age.secrets."cloudflare".path;
    #   group = "nginx";
    #   extraDomainNames = [ "*.elvivero.es" ];
    # };
  };
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud29;
      appstoreEnable = true;
      hostName = "en.elvivero.es";
      https = true;
      datadir = "/mnt/raid/nextcloud";
      database.createLocally = true;
      maxUploadSize = "20G";
      config = {
        dbtype = "mysql";
        adminpassFile = "/mnt/raid/nextcloud-admin-pass";
      };
      settings = {
        "default_phone_region" = "ES";
        "maintenance_window_start" = 2;
        "memories.exiftool" = "${lib.getExe pkgs.exiftool}";
        "memories.vod.ffmpeg" = "${lib.getExe pkgs.ffmpeg-headless}";
        "memories.vod.ffprobe" = "${pkgs.ffmpeg-headless}/bin/ffprobe";
        "overwriteprotocol" = "https";
      };
      phpOptions = {
        "opcache.interned_strings_buffer" = 16;
      };
    };
    nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      # useACMEHost = "elvivero.es";
      enableACME = true;
    };
    ddclient = {
      enable = true;
      protocol = "cloudflare";
      username = "token";
      zone = "elvivero.es";
      domains = [ "en.elvivero.es" ];
      use = "web, web=https://ipinfo.io/ip";
      passwordFile = "/mnt/raid/cloudflare-dns-zone-apikey";
    };
  };
  systemd.services.nextcloud-cron = {
    path = [pkgs.perl];
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
