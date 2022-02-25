{ config, lib, pkgs, ... }: {
  options.custom.services.moodle-dl = {
    enable = lib.mkEnableOption "Enable moodle downloader service";
  };
  config = lib.mkIf config.custom.services.moodle-dl.enable {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.containers."moodle-dl" = {
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
