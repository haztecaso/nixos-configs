{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services.moodle-dl;
  i2s = lib.strings.floatToString;
  script = pkgs.writeScriptBin "moodle-dl" ''
    #!${pkgs.runtimeShell}
    FOLDER=/var/lib/syncthing/uni-moodle/ 
    cd $FOLDER || { echo '$FOLDER does not exist' ; exit 1; }
    ln -fs ${config.age.secrets."moodle-dl.conf".path} config.json
    ${pkgs.moodle-dl}/bin/moodle-dl
  '';
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
    custom.services.syncthing.enable = true;
    services.cron = {
      enable = true;
      systemCronJobs = [
        ''*/${i2s cfg.frequency} * * * *  root . /etc/profile; ${script}/bin/moodle-dl''
      ];
    };
    age.secrets."moodle-dl.conf".file = ../../../secrets/moodle-dl.age;
  };
}
