{ config, pkgs, ... }: {
  services.hydra = {
    enable = true;
    hydraURL = "http://nas:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };
  networking.firewall = {
    allowedTCPPorts = [ 3000 ];
    allowedUDPPorts = [ 3000 ];
  };
}
