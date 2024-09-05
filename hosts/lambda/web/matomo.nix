{ ... }: {
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
    mysqlBackup.databases = [ "matomo" ];
  };
}
