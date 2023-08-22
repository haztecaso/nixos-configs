
{ config, lib, pkgs, ... }: {
  services.nginx.virtualHosts.meshcentral = {
    enableACME = true;
    forceSSL = true;
    serverName = "meshcentral.haztecaso.com";
    extraConfig = ''
      error_log syslog:server=unix:/dev/log debug;
      access_log syslog:server=unix:/dev/log,tag=meshcentral;

      proxy_send_timeout 330s;
      proxy_read_timeout 330s;
    '';
    locations."/" = {
      proxyPass = "http://nas:4001";
      extraConfig = ''
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
      '';
    };
  };
}
