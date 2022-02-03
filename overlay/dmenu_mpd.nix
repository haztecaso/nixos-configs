{ pkgs, ...}:
pkgs.writeScriptBin "dmenu_mpd"
''
  #!${pkgs.runtimeShell}
  #TODO: add at end
  #TODO: add after current 
  #TODO: clear and addclear and add
  #TODO: current to playlist
  #TODO: current album to playlist
  time=1.5

  consume(){
      OUT=$(${pkgs.mpc_cli}/bin/mpc consume | sed -n 's/^.*consume: \([a-z]\+\).*$/\1/p')
      echo $OUT
      message $time "consume $OUT"
  }

  crossfade() {
    local crossfade=`echo -e "0\n5" | ${pkgs.dmenu}/bin/dmenu -l 30 -i -p "Crossfade"`
    ${pkgs.mpc_cli}/bin/mpc crossfade $crossfade
  }

  current() {
    #echo -e `${pkgs.mpc_cli}/bin/mpc current -f "%track% - %title% - %artist% - %album%"` | ${pkgs.dmenu}/bin/dmenu -l 30 -i -p "Crossfade"
    #echo -e `${pkgs.mpc_cli}/bin/mpc current` | ${pkgs.dmenu}/bin/dmenu -l 30 -i -p "Crossfade"
    message $time "$(${pkgs.mpc_cli}/bin/mpc current)"
  }

  random(){
      OUT=$(${pkgs.mpc_cli}/bin/mpc random | sed -n 's/^.*random: \([a-z]\+\).*$/\1/p')
      echo $OUT
      message $time "random $OUT"
  }

  seek() {
    local seek=`echo -e "[+-]\n[<HH:MM:SS>]\nor\n<[+-]0-100>%>" | ${pkgs.dmenu}/bin/dmenu -l 30 -i -p "Seek"`
    ${pkgs.mpc_cli}/bin/mpc seek "$seek"
  }

  library() {
    local artist=`${pkgs.mpc_cli}/bin/mpc list albumartist | ${pkgs.dmenu}/bin/dmenu -l 30 -i -p "Artist"`
    local albumlist=`${pkgs.mpc_cli}/bin/mpc list album artist "$artist"`
    local album=`echo -e "[ALL]\n$albumlist" | ${pkgs.dmenu}/bin/dmenu -l 30 -i -p "Album"`

    if [ -n "$album" ]; then
    ${pkgs.mpc_cli}/bin/mpc clear
      if [[ $album == '[ALL]' ]];
      then
        ${pkgs.mpc_cli}/bin/mpc find artist "$artist" | ${pkgs.mpc_cli}/bin/mpc add
      else
        ${pkgs.mpc_cli}/bin/mpc find artist "$artist" album "$album" | ${pkgs.mpc_cli}/bin/mpc add
      fi
    ${pkgs.mpc_cli}/bin/mpc play
    fi
  }

  playlist() {
    local track=`${pkgs.mpc_cli}/bin/mpc playlist -f "%position% - %title% - %artist% - %album%" | ${pkgs.dmenu}/bin/dmenu -l 30 -i -l 5 -p "Track"`
    ${pkgs.mpc_cli}/bin/mpc play "''${track%% *}"
  }


  load() {
    local load=`${pkgs.mpc_cli}/bin/mpc lsplaylists | ${pkgs.dmenu}/bin/dmenu -l 30 -i -l 5 -p "Track"`
    if [ -n "$load" ]; then
        ${pkgs.mpc_cli}/bin/mpc clear
        ${pkgs.mpc_cli}/bin/mpc load "$load"
        ${pkgs.mpc_cli}/bin/mpc play
    fi
  }


  RESULT=`echo -e "Library\nPlaylist\nLoad\nRandom\nSeek\nConsume\nCrossfade\nCurrent\nUpdate" | ${pkgs.dmenu}/bin/dmenu -l 30 -i -p "Music"`

  case "$RESULT" in
    Consume) consume ;;
    Crossfade) crossfade ;;
    Current) current ;;
    Random) random ;;
    Repeat) ${pkgs.mpc_cli}/bin/mpc repeat ;;
    Single) ${pkgs.mpc_cli}/bin/mpc single ;;
    Seek) seek ;;
    Update) ${pkgs.mpc_cli}/bin/mpc update;;
    Library) library ;;
    Playlist) playlist ;;
    Load) load ;;
  esac

''
