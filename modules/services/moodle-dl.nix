{ config, lib, pkgs, ... }: let
  cfg = config.custom.services.moodle-dl;
  i2s = lib.strings.floatToString;
  script = pkgs.writeScriptBin "moodle-dl" ''
    #!${pkgs.runtimeShell}
    FOLDER=${cfg.folder}
    cd $FOLDER || { echo '$FOLDER does not exist' ; exit 1; }
    ln -fs ${cfg.configFile} config.json
    ${pkgs.moodle-dl}/bin/moodle-dl
  '';
in {
  options = with lib; {
    enable = mkEnableOption "Enable moodle downloader service";
    frequency = mkOption {
      type = types.int;
      default = 10;
      description = "frequency of cron job in minutes";
    };
    folder = mkOption {
      type = types.str;
      example = "/var/lib/syncthing/uni-moodle/";
      description = "path of moodle-dl folder";
    };
    configFile = mkOption {
      type = types.path;
      description = "path of moodle-dl config file."; 
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.moodle-dl ];
    services.cron = {
      enable = true;
      systemCronJobs = let
        freq = lib.strings.floatToString cfg.frequency;
      in [
        ''*/${freq} 0-2,4-23 * * *  root . /etc/profile; ${script}/bin/moodle-dl''
      ];
    };
  };
}
