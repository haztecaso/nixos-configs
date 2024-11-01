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
            try_files $uri $uri.html $uri/ =404;
            error_log /var/log/nginx/bufanda-error.log warn;
            access_log /var/log/nginx/bufanda-access.log;
          '';
        };
        "tools.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          root = "/var/www/tools.bufanda.cc/";
          extraConfig = ''
            error_page 404 /404.html;
            try_files $uri $uri.html $uri/ =404;
            error_log /var/log/nginx/tools-bufanda-error.log warn;
            access_log /var/log/nginx/tools-bufanda-access.log;
          '';
        };
        "mapa.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          root = "/var/www/mapa.bufanda.cc/";
          extraConfig = ''
            error_page 404 /404.html;
            try_files $uri $uri.html $uri/ =404;
            error_log /var/log/nginx/mapa-bufanda-error.log warn;
            access_log /var/log/nginx/mapa-bufanda-access.log;
          '';
        };
        "dev.${host}" = {
          useACMEHost = host;
          forceSSL = true;
          serverName = "~^(?<sub>\\w+)\\.dev\\.bufanda\\.cc$";
          root = "/var/www/dev.bufanda.cc/$sub";
          extraConfig = ''
            error_page 404 /404.html;
            try_files $uri $uri.html $uri/ =404;
            error_log /var/log/nginx/dev-bufanda-error.log warn;
            access_log /var/log/nginx/dev-bufanda-access.log;
          '';
        };
        "media-signup.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          locations."/".proxyPass = "http://nas:8097";
          extraConfig = ''
            error_log /var/log/nginx/media-signup-bufanda-error.log warn;
            access_log /var/log/nginx/media-signup-bufanda-access.log;
          '';
        };
        "media.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          locations."/".proxyPass = "http://nas:8096";
          extraConfig = ''
            error_log /var/log/nginx/jellyfin-bufanda-error.log warn;
            access_log /var/log/nginx/jellyfin-bufanda-access.log;
          '';
        };
        "radio.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          locations."/".proxyPass = "http://nas:8000/stream.mp3";
          extraConfig = ''
            error_log /var/log/nginx/radio-bufanda-error.log warn;
            access_log /var/log/nginx/radio-bufanda-access.log;
          '';
        };
        "music.bufanda.cc" = {
          useACMEHost = "bufanda.cc";
          forceSSL = true;
          locations."/".proxyPass = "http://nas:4747";
          extraConfig = ''
            error_log /var/log/nginx/navidrome-bufanda-error.log warn;
            access_log /var/log/nginx/navidrome-bufanda-access.log;
          '';
        };
        "dl.bufanda.cc" = {
          useACMEHost = host;
          forceSSL = true;
          locations."/" = {
            basicAuth = { user = "password"; };
            proxyPass = "http://nas:8998";
          };
          extraConfig = ''
            error_log /var/log/nginx/dl-bufanda-error.log warn;
            access_log /var/log/nginx/dl-bufanda-access.log;
          '';
        };
        "actual.bufanda.cc" = {
          useACMEHost = host;
          forceSSL = true;
          extraConfig = ''
            error_log /var/log/nginx/actual-bufanda-error.log warn;
            access_log /var/log/nginx/actual-bufanda-access.log;
          '';
          locations."/" = {
            proxyPass = "http://nas:5006";
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";

              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $host;
            '';
          };
        };
        "ombi.bufanda.cc" = {
          useACMEHost = host;
          forceSSL = true;
          extraConfig = ''
            error_log /var/log/nginx/ombi-bufanda-error.log warn;
            access_log /var/log/nginx/ombi-bufanda-access.log;
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
