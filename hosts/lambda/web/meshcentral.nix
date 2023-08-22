
{ config, lib, pkgs, ... }: {
  services.nginx = {
    virtualHosts = {
      ulogger = {
        enableACME = true;
        forceSSL = true;
        serverName = "meshcentral.haztecaso.com";
        extraConfig = ''
          error_log syslog:server=unix:/dev/log debug;
          access_log syslog:server=unix:/dev/log,tag=ulogger;
        '';
        locations."/" = {
          proxyPass = "http://nas:4001";
        };
      };
    };
  };
}
