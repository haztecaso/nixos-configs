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
