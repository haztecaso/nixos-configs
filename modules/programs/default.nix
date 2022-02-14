{ config, lib, pkgs, ... }:
let
in
{
  imports = [
    ./latex
    ./shells
    ./tmux
    ./vim
  ];
}
