{ config, lib, pkgs, ... }:
let
  backupDir = "/var/backups/vaultwarden";
in
{
  services = {
    vaultwarden = {
      enable = true;
      backupDir = backupDir;
      config = {
        signupsAllowed = false;
        domain = "https://bw.haztecaso.com";
        rocketPort = 8222;
      };
    };
    borgbackup.jobs.vaultwarden = {
      paths = backupDir;
      encryption.mode = "none"; 
      environment.BORG_RSH = "ssh -i /home/skolem/.ssh/id_rsa";
      repo = "ssh://skolem@nas:22/mnt/raid/backups/borg/vaultwarden";
      compression = "auto,zstd";
      startAt = "0/6:0:0";
      persistentTimer = true;
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
