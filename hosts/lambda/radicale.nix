{ config, lib, pkgs, ... }:
let 
  port = 8006;
in {
  services = {
    radicale = {
      enable = true;
      settings = {
        server.hosts = [ "localhost:${toString port}" ];
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/var/lib/radicale/htpasswd";
          htpasswd_encryption = "bcrypt";
        };
      };
    };
    nginx.virtualHosts.radicale = {
      useACMEHost = "haztecaso.com";
      forceSSL = true;
      serverName = "dav.haztecaso.com";
      locations."/".proxyPass = "http://127.0.0.1:${toString port}";
      extraConfig = ''
        error_log /var/log/nginx/radicale-error.log warn;
        access_log /var/log/nginx/radicale-access.log withHost;
      '';
    };
    fail2ban = {
      enable = true;
      jails.radicale = {
        filter = {
          INCLUDES.before = "common.conf";
          Definition = {
            failregex = "^.*Failed login attempt from .+ \(forwarded for '<ADDR>'\): '<F-USER>.+</F-USER>$";
            ignoreregex = "";
          };
        };
        settings = {
          backend = "systemd";
          port = "80,443";
          filter = "radicale[journalmatch='_SYSTEMD_UNIT=radicale.service']";
          banaction = "%(banaction_allports)s";
          maxretry = 3;
          bantime = 14400;
          findtime = 14400;
        };
      };
    };
  };
}
