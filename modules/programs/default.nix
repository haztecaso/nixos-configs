{ config, lib, pkgs, ... }:
let
in
{
  imports = [
    ./shells
    ./tmux
    ./vim
  ];
}
