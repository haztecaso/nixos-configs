{ config, lib, pkgs, ... }: {
  services.nginx.virtualHosts.ombi = {
    enableACME = true;
    forceSSL = true;
    serverName = "ombi.haztecaso.com";
    extraConfig = ''
      error_log syslog:server=unix:/dev/log debug;
      access_log syslog:server=unix:/dev/log,tag=ombi;
    '';
    locations."/" = {
      proxyPass = "http://nas:5055";
    };
  };
}
