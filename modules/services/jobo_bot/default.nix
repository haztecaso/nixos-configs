{ config, lib, pkgs, ... }:
let
  cfg = options.custom.services.jobo_bot;
in
{
  options.custom.services.jobo_bot = {
    enable = lib.mkEnableOption "jobo_bot service";
    signupsAllowed = lib.mkOption = {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ jobo_bot ];
    services.cron = {
      enable = true;
      systemCronJobs = [
        "*/10 * * * *  ${pkgs.jobo_bot} --conf ${config.age.secrets."configs/jobo_bot.conf".path}"
      ];
    };
    age.secrets."configs/jobo_bot.conf".file = ../../../secrets/configs/jobo_bot.age;
  };
}
