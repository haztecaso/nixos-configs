{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services.music-server;
in
{
  options.custom.services.music-server = with lib; {
    enable = mkEnableOption "Enable music-server: mpd + icecast";
    library = mkOption {
      type = types.path;
      description = "Music libary directory."; 
    };
    playlistDir = mkOption {
      type = types.path;
      default = cfg.library + "/Playlists";
      description = "Mpd music directory";
    };
    mpdDbFile = mkOption {
      type = types.path;
      default = cfg.library + "/mpd.db";
      description = "Mpd database path";
    };
    mpdDataDir = mkOption {
      type = types.path;
      default = cfg.library + "/.mpd";
      description = "Mpd database path";
    };
  };

  config = lib.mkIf cfg.enable {
    users.extraGroups.users.members = [ "mpd" ];
    services = {
      mpd = {
        enable = true;
        dataDir = cfg.mpdDataDir;
        dbFile = cfg.mpdDbFile;
        musicDirectory = cfg.library;
        playlistDirectory = cfg.playlistDir;
        network.listenAddress = "nas";
        extraConfig = ''
          audio_output {
            type "shout"
            encoding "lame"
            name "NAS music stream"
            host "localhost"
            port "8000"
            mount "/stream.mp3"
            user "mpd"
            password "mpd"
            bitrate "160"
            format "44100:16:1"
          }
        '';
      };
      icecast = {
        enable = true;
        hostname = "nas";
        admin.password = "pass";
        extraConf = ''
          <mount type="normal">
            <mount-name>/stream.mp3</mount-name>
            <username>mpd</username>
            <password>mpd</password>
          </mount>
        '';
      };
      mopidy = {
        enable = true;
        extensionPackages = with pkgs; [ mopidy-iris ];
        configuration = ''
          [file]
          enabled = true
          media_dirs = /mnt/raid/music/Library/Artists/

          [http]
          enabled = true
          hostname = 0.0.0.0

          [iris]
          enabled = true
        '';
      };
    };
    networking.firewall = {
      allowedUDPPorts = [ 6600 6680 ];
      allowedTCPPorts = [ 6600 6680 ];
    };
    users.users.mopidy.extraGroups = [ "users" "audio" ];
  };
}
