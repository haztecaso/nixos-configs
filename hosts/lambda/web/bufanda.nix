{ config, lib, pkgs, ... }:
let
  host = "bufanda.cc";
  root = "/var/www/bufanda.cc";
in
{
  services = {
    nginx = {
      virtualHosts = {
        "${host}" = {
          useACMEHost = host;
          forceSSL = true;
          root = "${root}";
          # locations."/".return = "301 https://es.wikipedia.org/wiki/Bufanda";
          extraConfig = ''
            expires 1d;
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=bufanda;
            try_files $uri $uri.html $uri/ =404;
          '';
        };
        "tools.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          root = "/var/www/tools.bufanda.cc/";
          extraConfig = ''
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=toolsbufanda;
            try_files $uri $uri.html $uri/ =404;
          '';
        };
        "mapa.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          root = "/var/www/mapa.bufanda.cc/";
          extraConfig = ''
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=mapabufanda;
            try_files $uri $uri.html $uri/ =404;
          '';
        };
        "cache.${host}" = {
          useACMEHost = host;
          forceSSL = true;
          locations."/".proxyPass = "http://nas:5555";
        };
        "dev.${host}" = {
          useACMEHost = host;
          forceSSL = true;
          serverName = "~^(?<sub>\\w+)\\.dev\\.bufanda\\.cc$";
          root = "/var/www/dev.bufanda.cc/$sub";
          extraConfig = ''
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=devbufanda;
            try_files $uri $uri.html $uri/ =404;
          '';
        };
        "media-signup.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          locations."/".proxyPass = "http://nas:8097";
        };
        "media.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          locations."/".proxyPass = "http://nas:8096";
        };
        "radio.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          locations."/".proxyPass = "http://nas:8000/stream.mp3";
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
