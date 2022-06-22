{ config, lib, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./irssi.nix
    ./nnn.nix
    ./ranger.nix
    ./shells.nix
  ];
}
