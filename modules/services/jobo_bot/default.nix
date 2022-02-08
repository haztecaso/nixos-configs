{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services.jobo_bot;
in
{
  options.custom.services.jobo_bot = {
    enable = lib.mkEnableOption "jobo_bot service";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ jobo_bot ];
    services.cron = {
      enable = true;
      systemCronJobs = [
        "*/1 * * * *  root . /etc/profile; ${pkgs.jobo_bot}/bin/jobo_bot --conf ${config.age.secrets."jobo_bot.conf".path}"
      ];
    };
    age.secrets."jobo_bot.conf".file = ../../../secrets/jobo_bot.age;
  };
}
