{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services.moodle-dl;
  i2s = lib.strings.floatToString;
in
{
  options.custom.services.moodle-dl = with lib; {
    enable = mkEnableOption "Enable moodle downloader service";
    frequency = mkOption {
      type = types.int;
      default = 10;
      description = "frequency of cron job in minutes";
    };
  };
  config = lib.mkIf config.custom.services.moodle-dl.enable {
    environment.systemPackages = with pkgs; [ moodle-dl ];
    services.cron = {
      enable = true;
      systemCronJobs = [
        ''*/${i2s cfg.frequency} * * * *  root . /etc/profile; ${pkgs.moodle-dl}/bin/moodle-dl -c ${config.age.secrets."moodle-dl.conf"}''
      ];
    };
    age.secrets."moodle-dl.conf".file = ../../../secrets/moodle-dl.age;
  };
}
