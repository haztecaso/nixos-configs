{ config, lib, pkgs, ... }: {
  options.custom.services.moodle-dl = {
    enable = lib.mkEnableOption "Enable moodle downloader service";
  };
  config = lib.mkIf config.custom.services.moodle-dl.enable {
      environment.systemPackages = [ pkgs.moodle-dl ];
  };
}
