{ pkgs, ... }:
let
  keys = import ./ssh-keys.nix;
in
{

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
    gc.automatic = true;
  };

  boot.cleanTmpDir = true;

  time.timeZone = "Europe/Madrid";

  users.users.root.openssh.authorizedKeys.keys = [ keys.skolem ];

  environment.systemPackages = with pkgs; [
    git
    ranger
    rsync
  ];

  programs = {
    bash = {
      shellAliases = {
        ".." = "cd ..";
        "r" = "ranger";
        "agenix" = "nix run github:ryantm/agenix --"; 
      };
    };
  };

  system.stateVersion = "21.11";
}
