{ pkgs, inputs, ... }: {
  services = {
    nginx.virtualHosts = {
      "haztecaso.com" = {
        enableACME = true;
        forceSSL = true;
        # root = inputs.www-haztecaso;
        root = "/var/www/haztecaso.com";
      };
      "www.haztecaso.com" = {
        enableACME = true;
        forceSSL = true;
        locations."/".return = "301 https://haztecaso.com$request_uri";
      };
    };
  };
}