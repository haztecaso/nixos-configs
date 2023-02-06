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
  networking.firewall.allowedTCPPorts = [ 4747 ];
  users.users.navidrome = {
      isSystemUser = true;
      group = "navidrome";
      extraGroups = [ "users" ];
  };
  users.groups.navidrome = { };
}
