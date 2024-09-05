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
          error_log syslog:server=unix:/dev/log debug;
          access_log syslog:server=unix:/dev/log,tag=ulogger;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:4007";
        };
      };
    };
  };
}
