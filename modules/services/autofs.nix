{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services.vaultwarden;
in
{
  options.custom.services.autofs = with lib; {
    enable = mkEnableOption "Enable autofs automounting daemon.";
  };
  config = lib.mkIf cfg.enable {
      services.autofs = {
          enable = true;
          autoMaster = let 
            mapConf = pkgs.writeText "auto" ''
              nas -fstype=fuse,rw,nodev,nonempty,noatime,allow_other,max_read=65536 :ssfs\#root@myserver.example.com\:/mnt/raid
            '';
          in ''
          '';
      };
  };
}
