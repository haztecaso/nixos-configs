{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services.jobo_bot;
  i2s = lib.strings.floatToString;
in
{
  options.custom.services.jobo_bot = {
    enable = lib.mkEnableOption "jobo_bot service";
    frequency = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "frequency of cron job in minutes";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ jobo_bot ];
    services.cron = {
      enable = true;
      systemCronJobs = [
        "*/${i2s cfg.frequency} * * * *  root . /etc/profile; ${pkgs.jobo_bot}/bin/jobo_bot --conf ${config.age.secrets."jobo_bot.conf".path}"
      ];
    };
    age.secrets."jobo_bot.conf".file = ../../../secrets/jobo_bot.age;
  };
}
