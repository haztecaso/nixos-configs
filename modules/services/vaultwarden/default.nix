{ config, lib, pkgs, ... }:
let
  cfg = options.custom.services.vaultwarden;
in
{
  options.custom.services.vaultwarden = {
    enable = lib.mkEnableOption "custom vaultwarden service";
    signupsAllowed = lib.mkOption = {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      vaultwarden = {
        enable = true;
        backupDir = "/srv/backups/vaultwarden"; #TODO: ensure that this folder exists and vaultwarden can write to it
        config = {
          signupsAllowed = cfg.signupsAllowed;
          domain = "https://bw.haztecaso.com";
          rocketPort = 8222;
        };
      };
      nginx.virtualHosts.vaultwarden = {
        forceSSL = true;
        enableACME = true;
        serverName = "bw.haztecaso.com";
        locations."/".proxyPass = "http://127.0.0.1:8222";
      };
    };
  };
}
