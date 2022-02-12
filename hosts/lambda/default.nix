{ pkgs, ... }: {
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 3d";

  custom = {
    base = {
      hostname = "lambda";
      hostnameSymbol = "λ"; 
    };

    programs = {
      tmux.color = "#aaee00";
    };

    services = {
      vaultwarden.enable = true;
      syncthing.enable = true;
      jobo_bot = {
        enable = true;
        frequency = 20;
        prod = true;
      };
    };

    webserver = {
      enable = true;
      haztecaso.enable = true;
      lagransala.enable = false;
      elvivero.enable = true;
      matomo.enable = true;
      # thumbor.enable = true;
    };

    stateVersion = "21.11";
  };

}
