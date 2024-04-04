{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services.tailscale;
in
{
  options.custom.services.tailscale = with lib; {
    enable = mkEnableOption "Tailscale service and package.";
    hosts = mkOption {
      type = types.attrsOf (types.listOf types.str);
      description = "Tailscale /etc/hosts entries.";
      default = { };
      example = { "100.0.0.1" = [ "hostname" "hostname.lan" ]; };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tailscale ];
    services.tailscale.enable = true;
    networking = {
      firewall = {
        allowedUDPPorts = [ 41641 ];
        checkReversePath = "loose";
      };
      hosts = cfg.hosts;
    };
    custom.services.tailscale.hosts =
      let
        localNames = name: [ name "${name}.lan" "${name}.local" ];
      in
      {
        "100.84.40.96" = (localNames "lambda") ++ (localNames "netdata.lambda");
        "100.109.49.55" = localNames "beta";
        "100.70.238.47" = (localNames "realme8") ++ (localNames "itinerante");
        "100.82.152.102" = localNames "beta-mac";
        "100.77.159.135" = localNames "nas";
        "100.74.34.128" = localNames "elbrus";
        "100.101.76.71" = localNames "deambulante";
      };
  };
}
