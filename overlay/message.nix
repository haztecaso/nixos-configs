{ pkgs, ... }:
pkgs.writeScriptBin "message"
''
  #!${pkgs.runtimeShell}
  time=$1
  FONT='-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*'
  sw=$(${pkgs.xorg.xrandr}/bin/xrandr -q| sed -n 's/.*current[ ]\([0-9]*\).*/\1/p')
  sh=$(${pkgs.xorg.xrandr}/bin/xrandr -q| sed -n 's/^.*current[ ].\+x \([0-9]*\).\+[,| |\.].\+/\1/p')
  y=$(expr $sh / 2)
  w=$(${pkgs.dzen2}/bin/textwidth $FONT "$2")
  x=$(expr $sw - $w)
  x=$(expr $x / 2) 
  (echo "$2"; sleep $time) | ${pkgs.dzen2}/bin/dzen2 -bg black -fg green -fn $FONT -y $y -x $x -w $w -e 'onstart=uncollapse;button1=exit;button3=exit'
''
