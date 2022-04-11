{ config, lib, pkgs, ... }:
let
  cfg = config.services.custom.vaultwarden;
in
{
  options.services.custom.vaultwarden = with lib; {
    enable = mkEnableOption "custom vaultwarden service";
    signupsAllowed = mkOption {
      type = types.bool;
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
      nginx.virtualHosts = {
        vaultwarden = {
          enableACME = true;
          forceSSL = true;
          serverName = "bw.haztecaso.com";
          locations."/".proxyPass = "http://127.0.0.1:8222";
        };
        "vaultwarden_old" = {
          enableACME = true;
          forceSSL = true;
          serverName = "vault.haztecaso.com";
          locations."/".return = "301 https://bw.haztecaso.com$request_uri";
        };
      };
    };
  };
}
