#TODO: Use HMAC
# https://thumbor.readthedocs.io/en/latest/security.html
{ config, lib, pkgs, ... }: {
  options.custom.webserver.thumbor = {
    enable = lib.mkEnableOption "thumbor thumbnail service";
  };
  config = lib.mkIf config.custom.webserver.thumbor.enable {
    age.secrets."thumbor".file = ../../../secrets/thumbor.age;
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.containers."thumbor" = {
      image = "minimalcompact/thumbor:latest";
      ports = [ "8001:80" ];
      volumes = [ "${config.age.secrets."thumbor".path}:/app/thumbor.conf" ];
    };
    #TODO: Caching with nginx
    # virtualisation.oci-containers.containers."thumbor-nginx-proxy-cache" = {
    #   image = "minimalcompact/thumbor-nginx-proxy-cache:latest";
    #   ports = [ "8001:80" ];
    #   environment = {
    #     PROXY_CACHE_SIZE = "2g";
    #     PROXY_CACHE_MEMORY_SIZE = "500m";
    #     PROXY_CACHE_INACTIVE = "300m";
    #   };
    #   volumes = [
    #     "/var/run/docker.sock:/tmp/docker.sock:ro"
    #     "/var/cache/thumbor:/var/cache/nginx"
    #   ];
    # };
    services = {
      nginx.virtualHosts = {
        thumbor = {
          enableACME = true;
          forceSSL = true;
          serverName = "img.haztecaso.com";
          locations."/" = {
            proxyPass = "http://127.0.0.1:8001";
          };
        };
      };
    };
  };
}
