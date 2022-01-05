{ config, pkgs, ... }:
let
  config_file = ../../../secrets/jobo_bot.conf;
in
{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/10 * * * *  ${pkgs.jobo_bot} --conf ${config_file}"
    ];
  };
}
