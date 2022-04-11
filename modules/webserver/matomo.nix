{ config, lib, pkgs, ... }: {
  options.custom.webserver.matomo = {
    enable = lib.mkEnableOption "matomo analytics";
  };
  config = lib.mkIf config.custom.webserver.matomo.enable {
    services = {
      matomo = {
        enable = true;
        hostname = "matomo.haztecaso.com";
        nginx = {
          serverName = "matomo.haztecaso.com";
          forceSSL = true;
          enableACME = true;
          extraConfig = ''
            error_log syslog:server=unix:/dev/log debug;
            access_log syslog:server=unix:/dev/log,tag=matomo;
          '';
        };
      };
      mysql = {
        enable = true;
        package = pkgs.mariadb;
        ensureDatabases = [ "matomo" ];
        ensureUsers = [
          {
            name = "matomo";
            ensurePermissions = {
              "matomo.*" = "ALL PRIVILEGES";
            };
          }
        ];
      };
    };
  };
}