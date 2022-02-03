{ pkgs, ... }:
let
  path = "~/Documents/uni";
in
pkgs.writeScriptBin "uni-cd"
''
  #!${pkgs.runtimeShell}
  current=$(${pkgs.uni-schedule}/bin/uni-schedule -g moodle)
  if [ -z "$current" ]; then
    course=$(ls ~/Documents/uni/Actuales/ | ${pkgs.smenu}/bin/smenu -Mdcm Asignatura)
    echo ~/Documents/uni/Actuales/$course
  else
    firefox --new-window $current
  fi
''
