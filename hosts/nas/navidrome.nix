{ config, pkgs, ... }: {
  services.navidrome = {
      enable = true;
      settings = {
          Address = "0.0.0.0";
          Port = 4747;
          MusicFolder = "/mnt/raid/music/Library/";
          PlaylistsPath = "/mnt/raid/music/Library/Playlists/";
          EnableCoverAnimation = false;
          AuthWindowLength = "60s";
      };
  };
  services.fail2ban = {
    enable = true;
    jails.navidrome = {
      filter = {
        INCLUDES.before = "common.conf";
        Definition = {
          failregex = ''^.*msg="Unsuccessful login".*X-Real-Ip:\[<ADDR>\]'';
          ignoreregex = "";
        };
      };
      settings = {
        backend = "systemd";
        port = "80,443";
        filter = "navidrome[journalmatch='_SYSTEMD_UNIT=navidrome.service']";
        banaction = "%(banaction_allports)s";
        maxretry = 5;
        bantime = 14400;
        findtime = 14400;
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 4747 ];
  users.users.navidrome = {
      isSystemUser = true;
      group = "navidrome";
      extraGroups = [ "media" ];
  };
  users.groups.navidrome = { };
}
