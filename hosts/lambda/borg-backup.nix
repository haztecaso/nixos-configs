# TODO:
# Conseguir que el servicio de borg funcione
# Incluir backups de:
# - vaultwarden
# - gitea
# - bases de datos: mysql
# - matomo

{ config, pkgs, ... }: {
  # environment.systemPackages = [ pkgs.borgbackup ];
  # services.borgbackup.jobs = {
  #   webs = {
  #     paths = "/var/www/";
  #     exclude = [ "/var/www/haztecaso.com/radio-old/" ];
  #     encryption.mode = "none"; 
  #     environment.BORG_RSH = "ssh -i /home/skolem/.ssh/id_rsa";
  #     repo = "ssh://skolem@nas:22/mnt/raid/backups/borg/lambda";
  #     compression = "auto,zstd";
  #     # startAt = "*:*:0"; # For debuggin
  #     startAt = "0/6:0:0";
  #   };
  # };
}
