{ config, lib, pkgs, ... }:
{
  imports = [
    ./irssi.nix
    ./nnn.nix
    ./ranger.nix
    ./shells.nix
  ];
}
