{ ... }:
let
  root = "/var/www/enelpetirrojo.com";
  host = "enelpetirrojo.com";
in
{
  services = {
    nginx = {
      virtualHosts = {
        "*.${host}" = {
          serverName = "*.${host}";
          useACMEHost = host;
          addSSL = true;
          locations."/".return = "301 https://${host}$request_uri";
        };
        "${host}" = {
          useACMEHost = host;
          forceSSL = true;
          root = "${root}";
          extraConfig = ''
            expires 1d;
            error_page 404 /404.html;
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=enelpetirrojo;
            try_files $uri $uri.html $uri/ =404;
          '';
        };
      };
    };
  };
}
