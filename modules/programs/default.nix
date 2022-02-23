{ config, lib, pkgs, ... }:
let
in
{
  imports = [
    ./latex
    ./ranger
    ./shells
    ./tmux
    ./vim
  ];
}
