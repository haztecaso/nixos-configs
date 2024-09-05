{ ... }:
{
  services = {
    nginx = {
      virtualHosts = {
        "enelpetirrojo.com" = {
          useACMEHost = "enelpetirrojo.com";
          forceSSL = true;
          root = "/var/www/enelpetirrojo.com";
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
