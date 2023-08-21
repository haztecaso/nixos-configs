{ config, pkgs, ... }:
{
  services = {
    prowlarr = {
      enable = true;
      openFirewall = true;
    };

    radarr = {
      enable = true;
      group = "media";
      openFirewall = true;
    };

    sonarr = {
      enable = true;
      group = "media";
      openFirewall = true;
    };

    # bazarr = {
    #   enable = true;
    #   group = "media";
    #   openFirewall = true;
    # };

    transmission = {
      enable = true;
      group = "media";
      openFirewall = true;
      openPeerPorts = true;
      settings = {
        rpc-bind-address = "nas";
        rpc-host-whitelist = "nas";
        rpc-whitelist-enabled = false;
        rpc-port = 9091;
      };
      openRPCPort = true;
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    # jellyseerr = {
    #   enable = true;
    #   openFirewall = true;
    #   port = 5055;
    # };

    ombi = {
      enable = true;
      openFirewall = true;
      port = 5055;
    };
  };

  users.groups."media" = { 
    members = [ "skolem" ];
  };
}
