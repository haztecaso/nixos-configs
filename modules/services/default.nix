{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services;
in
{
  imports = [
    ./autofs.nix
    ./fava.nix
    ./moodle-dl.nix
    ./tailscale.nix
  ];

  options.custom.services = with lib; {
    netdata.enable = mkEnableOption "Enable netdata web panel.";
  };

  config = with lib; mkMerge [
    (mkIf cfg.netdata.enable (
      let
        cfg = config.custom.services.netdata;
        port = 8004;
        serverName = "netdata.lambda.lan";
      in
      {
        services = {
          netdata = {
            enable = true;
            config.web."default port" = port;
          };

          nginx.virtualHosts.netdata = {
            serverName = serverName;
            locations."/".proxyPass = "http://127.0.0.1:${toString port}";
          };
        };
      }
    ))
  ];
}
