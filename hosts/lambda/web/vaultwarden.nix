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
    nginx.virtualHosts = {
      vaultwarden = {
        enableACME = true;
        forceSSL = true;
        serverName = "bw.haztecaso.com";
        locations."/".proxyPass = "http://127.0.0.1:8222";
      };
    };
    borgbackup.jobs.vaultwarden = {
      paths = backupDir;
      encryption.mode = "none"; 
      environment.BORG_RSH = " -o StrictHostKeyChecking=nossh -i /home/skolem/.ssh/id_rsa -o StrictHostKeyChecking=no";
      repo = "ssh://skolem@nas:22/mnt/raid/backups/borg/vaultwarden";
      compression = "auto,zstd";
      startAt = "3:30:0";
      persistentTimer = true;
      prune.keep = {
        within = "1d";
        daily = 7;
        weekly = 4;
        monthly = 6;
        yearly = 4;
      };
    };
  };
  systemd.tmpfiles.rules = [ "d ${backupDir} - vaultwarden vaultwarden 7d" ];
  systemd.timers.backup-vaultwarden.timerConfig.OnCalendar = "3:0:0";
}
