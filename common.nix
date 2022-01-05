{ pkgs, ... }: {

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

  users.users.root.openssh.authorizedKeys.keyFiles = [ ./secrets/authorized_keys ];

  environment.systemPackages = with pkgs; [ git rsync ranger ];

  programs = {
    bash = {
      shellAliases = {
        ".." = "cd ..";
        "r" = "ranger";
      };
    };
  };

  system.stateVersion = "21.11";
}
