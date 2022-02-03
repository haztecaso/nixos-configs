{ pkgs, ...}:
pkgs.writeScriptBin "dmenu_run_history"
''
  #!${pkgs.runtimeShell}
  mkdir -p $HOME/.cache/dmenu
  cachedir="$HOME/.cache/dmenu"
  cache=$cachedir/dmenu_run
  historyfile=$cachedir/dmenu_history
  IFS=:
  if stest -dqr -n "$cache" $PATH; then
      stest -flx $PATH | sort -u > "$cache"
  fi
  unset IFS
  awk -v histfile=$historyfile '
      BEGIN {
          while( (getline < histfile) > 0 ) {
              sub("^[0-9]+\t","")
              print
              x[$0]=1
          }
      } !x[$0]++ ' "$cache" \
      | ${pkgs.dmenu}/bin/dmenu "$@" \
      | awk -v histfile=$historyfile '
          BEGIN {
              FS=OFS="\t"
              while ( (getline < histfile) > 0 ) {
                  count=$1
                  sub("^[0-9]+\t","")
                  fname=$0
                  history[fname]=count
              }
              close(histfile)
          }

          {
              history[$0]++
              print
          }

          END {
              if(!NR) exit
              for (f in history)
                  print history[f],f | "sort -t '\t' -k1rn >" histfile
          }
      ' \
      | while read cmd; do ${pkgs.runtimeShell} -c "$cmd" & done
''
