{ pkgs, ... }:
pkgs.writeScriptBin "deploy"
''
  #!${pkgs.runtimeShell}
  echo "TODO"
''
