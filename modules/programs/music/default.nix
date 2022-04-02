{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.music;
in
{
  options.custom.programs.music = with lib; {
    enable = mkEnableOption "Enable various music programs";
    dir = mkOption {
      type = types.path;
      default = /home/skolem/Music/Library;
      description = "Mpd music directory";
    };
    playlistDir = mkOption {
      type = types.path;
      default = cfg.dir + "/Playlists";
      description = "Mpd music directory";
    };
    mpdDbFile = mkOption {
      type = types.path;
      default = cfg.dir + "/mpd.db";
      description = "Mpd database path";
    };
    mpdDataDir = mkOption {
      type = types.path;
      default = cfg.dir + "/.mpd";
      description = "Mpd database path";
    };
  };

  config = lib.mkIf cfg.enable (let
    conf = {
      services.mpd = {
        enable = true;
        musicDirectory = cfg.dir;
        playlistDirectory = cfg.playlistDir;
        dataDir = cfg.mpdDataDir;
        dbFile = builtins.toString cfg.mpdDbFile;
        extraConfig = ''
          audio_output {
            type "pulse"
            name "Pulseaudio"
            server "127.0.0.1"
          }
        '';
      };
      services.mpdris2 = {
        enable = true;
        mpd.host = "127.0.0.1";
      };
      programs.ncmpcpp = {
        enable = true;
        settings = {
          centered_cursor = true;
          user_interface = "alternative";
        };
        mpdMusicDir = cfg.dir;
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
          { key = "."; command = "show_lyrics"; } { key = "n"; command = "next_found_item"; }
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
  in {
    home-manager.users.skolem = { ... }: conf;
  });
}
