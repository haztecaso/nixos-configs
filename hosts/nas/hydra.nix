{ config, pkgs, ... }: {
  services = {
    hydra = {
      enable = true;
      hydraURL = "http://nas:3000";
      notificationSender = "hydra@localhost";
      buildMachinesFiles = [];
      useSubstitutes = true;
    };
    nix-serve = {
      enable = true;
      port = 5555;
      openFirewall = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };
  };
  networking.firewall = {
    allowedTCPPorts = [ 3000 ];
    allowedUDPPorts = [ 3000 ];
  };
}
