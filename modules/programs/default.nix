{ config, lib, pkgs, ... }:
{
  imports = [
    ./ranger.nix
    ./shells.nix
  ];
}
