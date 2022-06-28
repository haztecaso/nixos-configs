{ config, pkgs, ... }:
let
  #TODO: fix
  mpdnotify = pkgs.writeScriptBin "mpdnotify" ''
    #!${pkgs.runtimeShell}
    MUSIC_DIR=${config.services.mpd.musicDirectory}
    COVER="./current_mpd_cover.jpg"

    ARTIST=$(${pkgs.mpc_cli}/bin/mpc current -f '%artist%')
    TITLE=$(${pkgs.mpc_cli}/bin/mpc current -f '%title%')
    FILENAME=$(${pkgs.mpc_cli}/bin/mpc current -f '%file%')

    ${pkgs.ffmpeg}/bin/ffmpeg -i "$MUSIC_DIR$FILENAME" "$COVER" -y &> /dev/null
    STATUS=$? # Get the status of the previous command
    if [ "$STATUS" -eq 0 ]; then
        ARTLESS=false
    else
        DIR="$MUSIC_DIR$(${pkgs.coreutils}/bin/dirname "$FILENAME")"
        for CANDIDATE in "$DIR/cover."{png,jpg}; do
            if [ -f "$CANDIDATE" ]; then
                ARTLESS=false
                COVER="$CANDIDATE"
            fi
        done
    fi

    DUNSTIFY_CMD="${pkgs.dunst}/bin/dunstify -r 1002 -t 3000"
    [ "$ARTLESS" ] && DUNSTIFY_CMD="$DUNSTIFY_CMD -I $COVER"
    $DUNSTIFY_CMD "$ARTIST" "$TITLE"
  '';
  mpdnotifyd = pkgs.writeScriptBin "mpdnotifyd" ''
    #!${pkgs.runtimeShell}
    while true; do
      CURRENT=$(${pkgs.mpc_cli}/bin/mpc current --wait)
      STATUS=$?
      if [ "$STATUS" -eq 0 ]; then
        ${pkgs.runtimeShell} ${mpdnotify}/bin/mpdnotify
      else
          ${pkgs.coreutils}/bin/sleep 2
      fi
    done
  '';
in
{
  config = lib.mkIf config.custom.desktop.enable {
    home.packages = [ pkgs.dunst mpdnotify ];
 
    services.dunst = {
      enable = true;
      settings = {
        global = {
          "dmenu" = "${pkgs.dmenu}/bin/dmenu";
          "alignment" = "left";
          "markup" = "yes";
          "follow" = "none";
          "font" = "Hack Nerd Font 10";
          "width" = "340";
          "height" = "170";
          "offset" = "15x15";
          "frame_width" = "1";
          "origin" = "top-right";
          "format" = "<b>%s</b>\\n%b";
          "history_length" = "20";
          "horizontal_padding" = "8";
          "idle_threshold" = "240";
          "ignore_newline" = "no";
          "indicate_hidden" = "yes";
          "line_height" = "2";
          "monitor" = "0";
          "padding" = "10";
          "separator_color" = "frame";
          "separator_height" = "4";
          "show_age_threshold" = "60";
          "show_indicators" = "yes";
          "shrink" = "no";
          "sort" = "yes";
          "sticky_history" = "yes";
          "word_wrap" = "yes";
          "ellipsize" = "end";
          "transparency" = "10";
          "max_icon_size" = "150";
        };
        urgency_low = {
          "background" = "#000000";
          "foreground" = "#ffffff";
          "timeout" = "1";
        };
        urgency_normal = {
          "background" = "#222222";
          "foreground" = "#ffffff";
          "timeout" = "20";
        };
        urgency_critical = {
          "background" = "#801515";
          "foreground" = "#ffffff";
          "timeout" = "0";
        };
      };
    };
 
    systemd.user = {
      services.mpdnotifyd = {
        Unit.Description = "mpdnotify: send notifications on mpd events";
        Install.WantedBy = [ "multi-user.target" ];
        Service = {
          Type = "simple";
          Restart = "always";
          ExecStart = "${mpdnotifyd}/bin/mpdnotifyd";
        };
      };
      startServices = "sd-switch";
    };
  };
}
