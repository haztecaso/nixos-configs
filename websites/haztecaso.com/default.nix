{ pkgs, ... }: {
  services = {
    nginx.virtualHosts = {
      "haztecaso.com": {
        enableACME = true;
        forceSSL = true;
      };
    };
  };
}
