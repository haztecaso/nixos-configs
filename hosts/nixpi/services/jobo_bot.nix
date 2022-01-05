{ config, pkgs, ... }:
{
  age.secrets."jobo_bot" = ../../../secrets/jobo_bot.conf.age;
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/10 * * * *  ${pkgs.jobo_bot} --conf ${config.age.secrets."jobo_bot".path}"
    ];
  };
}
