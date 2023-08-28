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

    lidarr = {
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
