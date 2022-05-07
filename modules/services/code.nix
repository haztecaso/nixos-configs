{ config, lib, pkgs, ... }:
let
  cfg = config.services.custom.code-server;
  root = "/root/";
in
  {
    options.services.custom.code-server = with lib; {
      enable = mkEnableOption "code-server service";
      folder = mkOption {
        type = types.str;
        default = "/var/lib/code";
        description = "Data folder of code-server (docker volume binded to ${root}).";
      };
      port = mkOption {
        type = types.port;
        description = "Gitea internal listen port.";
      };
      serverName = mkOption {
        type = types.str;
        description = "Gitea nginx server name.";
      };
    };
    config = lib.mkIf cfg.enable {
      virtualisation.docker.enable = true;
      virtualisation.oci-containers.containers."code-server" = {
        image = "codercom/code-server:latest";
        ports = [ "${toString cfg.port}:8080" ];
        volumes = [ "${cfg.folder}/:${root}" ];
        user = "0:0";
        environment.DOCKER_USER="root";
      };
      services = {
        nginx.virtualHosts.code = {
          enableACME = true;
          forceSSL = true;
          serverName = cfg.serverName;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            extraConfig = ''
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection upgrade;
                proxy_set_header Accept-Encoding gzip;
            '';
          };
        };
      };
    };
  }
