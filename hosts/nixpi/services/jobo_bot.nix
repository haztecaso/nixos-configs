{ config, pkgs, ... }:
let
  config_file = ../../../secrets/jobo_bot.conf;
in
{
  age.secrets."jobo_bot.conf" = ../../../secrets/jobo_bot.conf.age;
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/10 * * * *  ${pkgs.jobo_bot} --conf ${config.age.secrets."jobo_bot.conf".path}"
    ];
  };
}
