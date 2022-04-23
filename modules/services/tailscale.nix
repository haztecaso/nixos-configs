{ config, lib, pkgs, ... }:
let
  cfg = config.services.custom.tailscale;
in
{
  options.services.custom.tailscale = with lib; {
    enable = mkEnableOption "Tailscale service and package.";
    hosts = mkOption {
      type = types.attrsOf (types.listOf types.str);
      description = "Tailscale /etc/hosts entries.";
      default = {};
      example = { "100.0.0.1" = [ "hostname" "hostname.lan" ]; };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tailscale ];
    services.tailscale.enable = true;
    networking = {
      firewall.allowedUDPPorts = [ 41641 ];
      hosts = cfg.hosts;
    };
  };
}
