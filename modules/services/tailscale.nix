{ config, lib, pkgs, ... }:
let
  cfg = config.services.custom.tailscale;
in
{
  options.services.custom.tailscale = with lib; {
    enable = mkEnableOption "Tailscale service and package.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tailscale ];
    services.tailscale.enable = true;
    networking.firewall.allowedUDPPorts = [ 41641 ];
  };
}
