{ ... }:
{
  services.nginx.virtualHosts."enelpetirrojo.com" = {
    useACMEHost = "enelpetirrojo.com";
    forceSSL = true;
    root = "/var/www/enelpetirrojo.com";
    extraConfig = ''
      expires 1d;
      error_page 404 /404.html;
      error_log /var/log/nginx/enelpetirrojo-error.log warn;
      access_log /var/log/nginx/enelpetirrojo-access.log;
      try_files $uri $uri.html $uri/ =404;
    '';
  };
}
