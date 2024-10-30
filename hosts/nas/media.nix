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

    # lidarr = {
    #   enable = true;
    #   group = "media";
    #   openFirewall = true;
    # };

    # TODO: fix and reenable
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

    # invidious = {
    #   enable = true;
    #   domain = "i.bufanda.cc";
    #   port = 3001;
    # };

    ombi = {
      enable = true;
      openFirewall = true;
      port = 5055;
    };

    fail2ban = {
      enable = true;
      jails = {
        jellyfin = {
          filter = {
            INCLUDES.before = "common.conf";
            Definition = {
              failregex = ''^.*Authentication request for .* has been denied \(IP: "<ADDR>"\)\.'';
              ignoreregex = "";
            };
          };
          settings = {
            backend = "systemd";
            port = "80,443";
            filter = "jellyfin[journalmatch='_SYSTEMD_UNIT=jellyfin.service']";
            banaction = "%(banaction_allports)s";
            maxretry = 5;
            bantime = 86400;
            findtime = 43200;
          };
        };
      };
    };
  };

  virtualisation = {
    docker.enable = true;
    oci-containers.containers."jfa-go" = {
      image = "hrfee/jfa-go";
      ports = [ "8097:8056" ];
      volumes = [
        # TODO: include config in this repo
        "/var/lib/jfa-go:/data"
        "/var/lib/jellyfin:/jf"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/jfa-go 0755 root root"
  ];

  networking.firewall.allowedTCPPorts = [ 111 3001 4001 5000 50000 ];

  users.groups."media" = { 
    members = [ "skolem" ];
  };
}
