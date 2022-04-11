# IDEAS
# Use only nginx with image_filter module:
# - https://charlesleifer.com/blog/nginx-a-caching-thumbnailing-reverse-proxying-image-server-/

{ config, lib, pkgs, ... }: {
  options.custom.webserver.thumbor = {
    enable = lib.mkEnableOption "thumbor thumbnail service";
  };
  config = lib.mkIf config.custom.webserver.thumbor.enable {
    age.secrets."thumbor".file = ../../secrets/thumbor.age;
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.containers."thumbor" = {
      image = "minimalcompact/thumbor:latest";
      ports = [ "8001:80" ];
      volumes = [ "${config.age.secrets."thumbor".path}:/app/thumbor.conf" ];
    };
    services = {
      nginx = {
        appendHttpConfig = ''
          proxy_cache_path /tmp/thumbor-cache levels=1:2 keys_zone=thumbor_cache:16M inactive=30d max_size=1000M;
        '';
        virtualHosts = {
          thumbor = {
            enableACME = true;
            forceSSL = true;
            serverName = "img.haztecaso.com";
            extraConfig = ''
              error_log syslog:server=unix:/dev/log debug;
              access_log syslog:server=unix:/dev/log,tag=thumbor;
            '';
            locations."/" = {
              proxyPass = "http://127.0.0.1:8001";
              extraConfig = ''
                proxy_cache thumbor_cache;
                proxy_cache_key $host$document_uri$is_args$args;
                proxy_cache_lock on;
                proxy_cache_valid 30d;
                proxy_cache_use_stale error timeout updating;
                proxy_http_version 1.1;
                expires 30d;
              '';
            };
          };
        };
      };
    };
  };
}
