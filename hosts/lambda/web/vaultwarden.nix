{ config, lib, pkgs, ... }:
{
  services = {
    vaultwarden = {
      enable = true;
      backupDir = "/srv/backups/vaultwarden"; #TODO: ensure that this folder exists and vaultwarden can write to it
      config = {
        signupsAllowed = false;
        domain = "https://bw.haztecaso.com";
        rocketPort = 8222;
      };
    };
    nginx.virtualHosts = {
      vaultwarden = {
        enableACME = true;
        forceSSL = true;
        serverName = "bw.haztecaso.com";
        locations."/".proxyPass = "http://127.0.0.1:8222";
      };
      "vaultwarden_old" = {
        enableACME = true;
        forceSSL = true;
        serverName = "vault.haztecaso.com";
        locations."/".return = "301 https://bw.haztecaso.com$request_uri";
      };
    };
  };
}