{ config, lib, pkgs, ... }:
let
  host = "bufanda.cc";
  root = "/var/www/bufanda.cc";
in
{
  security.acme.certs."${host}" = {
    dnsProvider = "cloudflare";
    credentialsFile = config.age.secrets."cloudflare".path;
    group = "nginx";
    extraDomainNames = [ "*.${host}" ];
  };
  services = {
    nginx = {
      virtualHosts = {
        "*.${host}" = {
          serverName = "*.${host}";
          useACMEHost = host;
          addSSL = true;
          locations."/".return = "404";
        };
        "${host}" = {
          useACMEHost = host;
          forceSSL = true;
          root = "${root}";
          extraConfig = ''
            expires 1d;
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=bufanda;
            try_files $uri $uri.html $uri/ =404;
          '';
        };
        "cache.${host}" = {
          useACMEHost = host;
          forceSSL = true;
          locations."/".proxyPass = "http://nas:5555";
        };
        "media.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          locations."/".proxyPass = "http://nas:8096";
        };
        "music.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          locations."/".proxyPass = "http://nas:4747";
        };
        "dl.bufanda.cc" = {
          useACMEHost = host;
          forceSSL = true;
          locations."/" = {
            basicAuth = { user = "password"; };
            proxyPass = "http://nas:8998";
          };
        };
        "remote.bufanda.cc" = {
          useACMEHost = host;
          forceSSL = true;
          extraConfig = ''
            access_log syslog:server=unix:/dev/log,tag=meshcentral;
            proxy_send_timeout 330s;
            proxy_read_timeout 330s;
          '';
          locations."/" = {
            proxyPass = "http://nas:4001";
          };
        };
        "ombi.bufanda.cc" = {
          useACMEHost = host;
          forceSSL = true;
          extraConfig = ''
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=ombi;
          '';
          locations."/" = {
            proxyPass = "http://nas:5055";
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
            '';
          };
        };
      };
    };
  };
}
