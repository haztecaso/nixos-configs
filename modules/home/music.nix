{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.music;
  commonConfig = {
      home.packages = [ pkgs.mpc_cli ];
      programs.ncmpcpp = {
        enable = true;
        settings = {
          centered_cursor = true;
          user_interface = "alternative";
        };
        bindings = [
          { key = "Q"; command = "quit"; }
          { key = "q"; command = "dummy"; }
          { key = "="; command = "show_clock"; }
          { key = "+"; command = "volume_up"; }
          { key = "j"; command = "scroll_down"; }
          { key = "k"; command = "scroll_up"; }
          { key = "ctrl-u"; command = "page_up"; }
          { key = "ctrl-d"; command = "page_down"; }
          { key = "u"; command = "page_up"; }
          { key = "d"; command = "page_down"; }
          { key = "h"; command = "previous_column"; }
          { key = "l"; command = "next_column"; }
          { key = "."; command = "show_lyrics"; }
          { key = "n"; command = "next_found_item"; }
          { key = "N"; command = "previous_found_item"; }
          { key = "J"; command = "move_sort_order_down"; }
          { key = "K"; command = "move_sort_order_up"; }
          { key = "h"; command = "jump_to_parent_directory"; }
          { key = "l"; command = "enter_directory"; }
          { key = "l"; command = "run_action"; }
          { key = "l"; command = "play_item"; }
          { key = "m"; command = "show_media_library"; }
          { key = "m"; command = "toggle_media_library_columns_mode"; }
          { key = "t"; command = "show_tag_editor"; }
          { key = "v"; command = "show_visualizer"; }
          { key = "G"; command = "move_end"; }
          { key = "g"; command = "move_home"; }
          { key = "U"; command = "update_database"; }
          { key = "s"; command = "reset_search_engine"; }
          { key = "s"; command = "show_search_engine"; }
          { key = "f"; command = "show_browser"; }
          { key = "f"; command = "change_browse_mode"; }
          { key = "x"; command = "delete_playlist_items"; }
          { key = "P"; command = "show_playlist"; }
        ];
      };
    };
in
{
  options.custom.programs.music = with lib; {
    enable = mkEnableOption "Enable music setup (nas: mpd server, clients: consumers).";
    client = {
      enable = mkEnableOption "Enable client (music player) config.";
    };
    server = {
      enable = mkEnableOption "Enable server (music streamer) config.";
      library = mkOption {
        type = types.path;
        description = "Music libary directory (read by mpd, beets)."; 
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
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.server.enable ( commonConfig // {
      services.mpd = {
        enable = true;
        musicDirectory = cfg.server.library;
        playlistDirectory = cfg.server.playlistDir;
        dataDir = cfg.server.mpdDataDir;
        dbFile = builtins.toString cfg.server.mpdDbFile;
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
    }))
    (lib.mkIf cfg.client.enable ( commonConfig // {
      services.mpdris2 = {
        enable = true;
        mpd.host = "nas";
      };
      programs.ncmpcpp = {
        mpdMusicDir = cfg.library;
        settings.mpd_host = "nas";
      };
    }))
  ];
}
