
{ config, lib, pkgs, ... }: {
  services.nginx = {
    virtualHosts = {
      meshcentral = {
        enableACME = true;
        forceSSL = true;
        serverName = "meshcentral.haztecaso.com";
        extraConfig = ''
          error_log syslog:server=unix:/dev/log debug;
          access_log syslog:server=unix:/dev/log,tag=meshcentral;
        '';
        locations."/" = {
          proxyPass = "http://nas:4001";
        };
      };
    };
  };
}
