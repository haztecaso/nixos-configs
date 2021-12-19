{ pkgs, ... }: {
  services = {
    nginx.virtualHosts = {
      vaultwarden = {
        forceSSL = true;
        enableACME = true;
        serverName = "bw.haztecaso.com";
        locations."/".proxyPass = "http://127.0.0.1:8222";
      };
    };
    vaultwarden = {
      enable = true;
      backupDir = "/srv/backups/vaultwarden"; #TODO: ensure that this folder exists and vaultwarden can write to it
      config = {
        signupsAllowed = false;
        domain = "https://bw.haztecaso.com";
        rocketPort = 8222;
      };
    };
  };
}
