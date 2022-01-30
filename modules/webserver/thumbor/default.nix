{ config, lib, pkgs, ... }: {
  options.custom.webserver.thumbor = {
    enable = lib.mkEnableOption "thumbor thumbnail service";
  };
  config = lib.mkIf config.custom.webserver.thumbor.enable {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.containers."thumbor" = {
      image = "minimalcompact/thumbor:latest";
      ports = [ "8001:80" ];
    services = {
      nginx.virtualHosts = {
        "thumbor" = {
          listen = [ { addr="0.0.0.0"; port=8001; } ];
          locations."/" = {
            proxyPass = "http://127.0.0.1:8001";
          };
        };
      };
    };
  };
}
