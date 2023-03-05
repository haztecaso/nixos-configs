{ config, pkgs, ... }: {
  services.borgbackup.jobs = {
    webs = {
      paths = "/var/www/";
      exclude = [ "/var/www/haztecaso.com/radio-old/" ];
      encryption.mode = "none"; 
      environment.BORG_RSH = "ssh -i /home/skolem/.ssh/id_rsa";
      repo = "ssh://skolem@nas/mnt/raid/backups/borg/lambda";
      compression = "auto,zstd";
      startAt = "daily";
    };
  };
}
