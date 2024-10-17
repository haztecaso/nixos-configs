{ config, lib, pkgs, ... }:
let cfg = config.custom.services.autofs;
in {
  options.custom.services.autofs = with lib; {
    enable = mkEnableOption "Enable autofs automounting daemon.";
  };
  config = lib.mkIf cfg.enable {
    services.autofs = {
      enable = true;
      autoMaster = let
        options = "-fstype=fuse,rw,sync,nodev,allow_other,follow_symlinks ";
        sshfs = "${pkgs.sshfs}/bin/sshfs";
        mapConf = pkgs.writeText "auto" ''
          nas ${options} :${sshfs}\#root@nas\:/mnt/raid
        '';
      in ''
        /mnt/auto/ file:${mapConf} -v
      '';
    };
    environment.systemPackages = [ pkgs.sshfs ];
  };
}
