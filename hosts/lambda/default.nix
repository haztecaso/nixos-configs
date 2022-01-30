{ pkgs, ... }: {
  imports = [ ./hardware.nix ];

  nix.gc.options = "--delete-older-than 3d";

  programs = {
    bash = {
      promptInit = ''export PS1="\[\e[00;34m\][\u@λ \w]\\$ \[\e[0m\]"'';
    };
    vim.defaultEditor = true;
  };


  custom = {
    base = {
      hostname = "lambda";
      tmux.color = "#eeaa00";
    };

    services = {
      vaultwarden.enable = true;
      syncthing.enable = true;
    };

    webserver = {
      enable = true;
      haztecaso.enable = true;
      lagransala.enable = false;
      elvivero.enable = true;
      matomo.enable = true;
    };

    stateVersion = "21.11";
  };

}
