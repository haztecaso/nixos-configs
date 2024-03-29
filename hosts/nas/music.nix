{ config, pkgs, ... }: 
let
  cfg = rec {
    library = "/mnt/raid/music/Library";
    playlistDir = library + "/Playlists";
    mpdDataDir = library + "/.mpd";
    mpdDbFile = library + "/mpd.db";
    beetsDbFile = library + "/beets.db";
  };
in
{
    services = {
      mpd = {
        enable = true;
        dataDir = cfg.mpdDataDir;
        dbFile = cfg.mpdDbFile;
        musicDirectory = cfg.library;
        playlistDirectory = cfg.playlistDir;
        network.listenAddress = "nas";
        extraConfig = ''
          auto_update "yes"
          auto_update_depth "6"
          audio_output {
            type "shout"
            encoding "lame"
            name "NAS music stream"
            host "localhost"
            port "8000"
            mount "/mpd.mp3"
            user "mpd"
            password "hackme"
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
            <mount-name>/mixxx.ogg</mount-name>
            <username>mixxx</username>
            <password>hackme</password>
          </mount>
          <mount type="normal">
            <mount-name>/mpd.mp3</mount-name>
            <username>mpd</username>
            <password>hackme</password>
          </mount>
          <mount type="normal">
            <mount-name>/stream.mp3</mount-name>
            <username>liquid</username>
            <password>soap</password>
          </mount>
        '';
      };
      liquidsoap.streams.liquidsoap-bufanda =
      pkgs.writeText "config.liq" ''
        set("tag.encodings",["UTF-8","ISO-8859-1"])

        day_playlist = playlist("${cfg.library}/radio/day.m3u")
        night_playlist = playlist("${cfg.library}/radio/night.m3u")
        set("tag.encodings",["UTF-8","ISO-8859-1"])

        playlists = switch([
          ({ 6h-22h }, day_playlist),
          ({ 22h-6h }, night_playlist),
        ])

        mixxx = blank.strip(
          max_blank=10.0, 
          input.http('http://localhost:8000/mixxx.ogg')
        )

        mpd = blank.strip(
          max_blank=10.0, 
          input.http('http://localhost:8000/mpd.mp3')
        )

        stream = fallback(track_sensitive=false, [
          mixxx,
          mpd,
          playlists,
          single('${cfg.library}/radio/error.mp3'),
        ])

        stream = mksafe(stream)

        output.icecast(%mp3,
          host = "localhost", port = 8000,
          user = "liquid", password = "soap",
          mount = "stream.mp3",
          name = "Radio Bufanda",
          description = "una radio aleatoria",
          stream)
      '';
      mopidy = {
        enable = false; #TODO: enable
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
    users.extraGroups.media.members = [ "mpd" "mopidy" "liquidsoap" ];
    # users.users.mopidy.group = "media";
    networking.firewall = {
      allowedUDPPorts = [ 6600 6680 8000 ];
      allowedTCPPorts = [ 6600 6680 8000 ];
    };

    home-manager.users.skolem = { ... }: {
      home.packages = [ pkgs.mpc_cli ];
      programs.beets = {
        enable = true;
        mpdIntegration.enableUpdate = true;
        settings = {
          library = cfg.beetsDbFile;
          directory = cfg.library;
          paths = {
            default = "Artists/$albumartist/[$original_year] - $album%aunique{}/%if{multidisc,CD $disc/}$track $title";
            "albumtype:soundtrack" = "Soundtracks/$album%aunique{}/$track $title";
            comp = "Compilations/$album%aunique/$track $title";
          };
          # TODO: plugins = [ "alternatives" "extrafiles" "lastgenre" ];
        };
      };
      programs.ncmpcpp = {
        enable = true;
        settings = {
          mpd_host = "nas";
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
      programs.ncmpcpp = {
        mpdMusicDir = cfg.library;
      };
    };
}
