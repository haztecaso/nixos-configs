{ config, ... }:
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
        rocketLog = "critical";
      };
    };
    fail2ban = {
      enable = true;
      jails = {
        vaultwarden = {
          filter = {
            INCLUDES.before = "common.conf";
            Definition = {
              failregex = "^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$";
              ignoreregex = "";
            };
          };
          settings = {
            backend = "systemd";
            port = "80,443";
            filter = "vaultwarden[journalmatch='_SYSTEMD_UNIT=vaultwarden.service']";
            banaction = "%(banaction_allports)s";
            maxretry = 5;
            bantime = 14400;
            findtime = 14400;
          };
        };
        vaultwarden-admin = {
          filter = {
            INCLUDES.before = "common.conf";
            Definition = {
              failregex = "^.*Invalid admin token\. IP: <ADDR>.*$";
              ignoreregex = "";
            };
          };
          settings = {
            backend = "systemd";
            port = "80,443";
            filter = "vaultwarden-admin[journalmatch='_SYSTEMD_UNIT=vaultwarden.service']";
            banaction = "%(banaction_allports)s";
            maxretry = 3;
            bantime = 14400;
            findtime = 14400;
          };
        };
      };
    };
    nginx.virtualHosts = {
      vaultwarden = {
        useACMEHost = "haztecaso.com";
        forceSSL = true;
        serverName = "bw.haztecaso.com";
        locations."/".proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.rocketPort}";
        extraConfig = ''
          error_log /var/log/nginx/vaultwarden-error.log warn;
          access_log /var/log/nginx/vaultwarden-access.log;
        '';
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
