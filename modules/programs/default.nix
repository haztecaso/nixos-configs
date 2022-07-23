{ config, lib, pkgs, ... }:
{
  imports = [
    ./nnn.nix
    ./ranger.nix
    ./shells.nix
  ];
}
