
{ config, lib, pkgs, ... }:
let
  cfg = config.custom.webserver.code;
in
{
  options.custom.webserver.code = with lib; {
    enable = mkEnableOption "code-server service";
    folder = mkOption {
      type = types.str;
      default = "/var/lib/code";
    };
  };
  config = lib.mkIf config.custom.webserver.thumbor.enable {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.containers."code-server" = {
      image = "codercom/code-server:latest";
      ports = [ "8002:8080" ];
      volumes = [
        "${cfg.folder}/.config:/home/coder/.config"
        "${cfg.folder}/project:/home/coder/project"
      ];
      user = "0:0";
      environment = { DOCKER_USER="root"; };
    };
    services = {
      nginx = {
        virtualHosts = {
          code = {
            enableACME = true;
            forceSSL = true;
            serverName = "code.haztecaso.com";
            locations."/" = {
              proxyPass = "http://127.0.0.1:8002";
            };
          };
        };
      };
    };
  };
}
