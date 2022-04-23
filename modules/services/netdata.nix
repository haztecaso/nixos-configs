{ config, lib, pkgs, ... }:
let
  cfg = config.services.custom.netdata;
in
{
  options.services.custom.netdata = with lib; {
    enable = mkEnableOption "Enable netdata web panel.";
    port = mkOption {
      type = types.port;
      description = "Netdata internal listen port.";
    };
    serverName = mkOption {
      type = types.str;
      description = "Netdata nginx server name.";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      netdata = {
        enable = true;
        config.web."default port" = cfg.port;
      };

      nginx.virtualHosts.netdata = {
        serverName = cfg.serverName;
        locations."/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
      };
    };
  };
}
