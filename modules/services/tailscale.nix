{ config, lib, pkgs, ... }:
let
  cfg = config.services.custom.tailscale;
  localNames = name: [ name "${name}.lan" "${name}.local" ];
in
{
  options.services.custom.tailscale = with lib; {
    enable = mkEnableOption "Tailscale service and package.";
    hosts = mkOption {
      type = types.attrsOf (types.listOf types.str);
      description = "Tailscale /etc/hosts entries.";
      default = {
        "100.84.40.96"   = localNames "lambda";
        "100.75.165.118" = localNames "beta";
        "100.70.238.47"  = localNames "realme8";
        "100.84.161.27"  = localNames "galois";
        "100.93.219.95"  = (localNames "raspi-music") ++ ["semuta.mooo.com"];
      };
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
