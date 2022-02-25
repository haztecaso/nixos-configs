{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services.jobo_bot;
  i2s = lib.strings.floatToString;
in
{
  options.custom.services.jobo_bot = with lib; {
    enable = mkEnableOption "jobo_bot service";
    frequency = mkOption {
      type = types.int;
      default = 30;
      description = "frequency of cron job in minutes";
    };
    prod = mkOption {
      type = types.bool;
      default = false;
      description = "enable production mode";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ jobo_bot ];
    services.cron = {
      enable = true;
      systemCronJobs = [
        ''*/${i2s cfg.frequency} * * * *  root . /etc/profile; ${pkgs.jobo_bot}/bin/jobo_bot --conf ${config.age.secrets."jobo_bot.conf".path} ${if cfg.prod then "--prod" else ""}''
      ];
    };
    age.secrets."jobo_bot.conf".file = ../../../secrets/jobo_bot.age;
  };
}
