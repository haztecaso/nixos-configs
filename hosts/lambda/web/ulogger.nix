{ ... }: {
  virtualisation = {
    docker.enable = true;
    oci-containers.containers."ulogger" = {
      image = "bfabiszewski/ulogger:latest";
      ports = [ "4007:80" ];
    };
  };
  services.nginx = {
    virtualHosts = {
      ulogger = {
        enableACME = true;
        forceSSL = true;
        serverName = "ulogger.haztecaso.com";
        extraConfig = ''
          error_log /var/log/nginx/ulogger-error.log warn;
          access_log /var/log/nginx/ulogger-access.log;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:4007";
        };
      };
    };
  };
}
