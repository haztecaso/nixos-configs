{ config, pkgs, ... }: {
  services = {
    # nix-serve = {
    #   enable = true;
    #   port = 5555;
    #   openFirewall = true;
    # };

    # prowlarr = {
    #   enable = true;
    #   openFirewall = true;
    # };

    # radarr = {
    #   enable = true;
    #   group = "media";
    #   openFirewall = true;
    # };

    # sonarr = {
    #   enable = true;
    #   group = "media";
    #   openFirewall = true;
    # };

    # bazarr = {
    #   enable = true;
    #   group = "media";
    #   openFirewall = true;
    # };

    # transmission = {
    #   enable = true;
    #   group = "media";
    #   openFirewall = true;
    #   openPeerPorts = true;
    #   settings = {
    #     rpc-bind-address = "nas";
    #     rpc-host-whitelist = "nas";
    #     rpc-whitelist-enabled = false;
    #   };
    #   openRPCPort = true;
    # };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };
  };

  users.groups."media" = { 
    members = [ "skolem" ];
  };
}
