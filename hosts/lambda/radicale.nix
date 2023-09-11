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
      nginx.virtualHosts.radicale = {
        enableACME = true;
        forceSSL = true;
        serverName = "dav.haztecaso.com";
        locations."/".proxyPass = "http://127.0.0.1:${toString port}";
      };
    };
  };
}
