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
      default = cfg.server.library + "/Playlists";
      description = "Mpd music directory";
    };
    mpdDbFile = mkOption {
      type = types.path;
      default = cfg.server.library + "/mpd.db";
      description = "Mpd database path";
    };
    mpdDataDir = mkOption {
      type = types.path;
      default = cfg.server.library + "/.mpd";
      description = "Mpd database path";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      mpd = {
        enable = true;
        dataDir = cfg.mpdDataDir;
        dbFile = cfg.mpdDbFile;
        # dbFile = builtins.toString cfg.server.mpdDbFile;
        musicDirectory = cfg.library;
        playlistDirectory = cfg.playlistDir;
        listenAddress = "nas";
        extraConfig = ''
          audio_output {
            type "httpd"
            name "NAS"
            encoder "lame"
            server "0.0.0.0"
            port "8000"
            bitrate "160"
          }
        '';
      };
    };
  };
}
