{ pkgs, ... }:
pkgs.writeScriptBin "deploy"
''
  #!${pkgs.runtimeShell}
  echo "deploy"
  echo "IT WORKS"
''
