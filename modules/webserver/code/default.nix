
{ config, lib, pkgs, ... }:
let
  cfg = config.custom.webserver.code;
in
{
  options.custom.webserver.code = with lib; {
    enable = mkEnableOption "code-server service";
    folder = mkOption {
      type = types.path;
      default = /var/lib/code;
    };
  };
  config = lib.mkIf config.custom.webserver.thumbor.enable {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.containers."code-server" = {
      image = "codercom/code-server:latest";
      ports = [ "8002:8080" ];
      volumes = [
        "${config.folder}/.config:/home/coder/.config"
        "${config.folder}/project:/home/coder/project"
      ];
      user = "0:0";
      environment = { DOCKER_USER="root"; };
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
            serverName = "code.haztecaso.com";
            extraConfig = ''
              error_log syslog:server=unix:/dev/log debug;
              access_log syslog:server=unix:/dev/log,tag=thumbor;
            '';
            locations."/" = {
              proxyPass = "http://127.0.0.1:8002";
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
