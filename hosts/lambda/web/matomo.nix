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
          error_log /var/log/nginx/matomo-error.log warn;
          access_log /var/log/nginx/matomo-access.log;
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
