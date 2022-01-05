{ pkgs, ... }: {
  services = {
    matomo = {
      enable = true;
      hostname = "matomo.haztecaso.com";
      nginx = {
        serverName = "matomo.haztecaso.com";
        forceSSL = true;
        enableACME = true;
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
}
