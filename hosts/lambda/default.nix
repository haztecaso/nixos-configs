{ pkgs, ... }: {
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 3d";

  programs = {
    vim.defaultEditor = true;
  };

  custom = {
    base.hostname = "lambda";

    programs = {
      tmux.color = "#aaee00";
      shells = {
        defaultShell = pkgs.bash; # TODO: Disable zsh for now, until I discover how to prolerly set EDITOR and VISUAL variables...
        hostnameSymbol = "λ"; 
      };
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
