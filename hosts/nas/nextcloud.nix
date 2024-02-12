{ config, pkgs, ... }: 
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
      package = pkgs.nextcloud27;
      appstoreEnable = true;
      hostName = "en.elvivero.es";
      https = true;
      datadir = "/mnt/raid/nextcloud";
      database.createLocally = true;
      config = {
        dbtype = "mysql";
        adminpassFile = "/mnt/raid/nextcloud-admin-pass";
        defaultPhoneRegion = "ES";
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
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
