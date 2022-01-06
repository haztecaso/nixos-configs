{ config, pkgs, ... }: let
  hostname = "nixpi";
  keys = import ../../ssh-keys.nix;
in
{
  imports = [ ./hardware-configuration.nix ];

  nix.gc.options = "--delete-older-than 3d";

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
      raspberryPi = {
        enable = true;
        uboot.enable = true;
        version = 3;
      };
    };
  };

  networking = {
    hostName = hostname;
    interfaces.eth0.useDHCP = true;
    firewall.allowedTCPPorts = [ 22 ];
  };

  console.keyMap = "es";

  environment.systemPackages = with pkgs; [ vim jobo_bot deploy ];

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
    cron = {
      enable = true;
      systemCronJobs = [
        "*/10 * * * *  ${pkgs.jobo_bot} --conf ${config.age.secrets."jobo_bot".path}"
      ];
    };
  };

  age.secrets."jobo_bot".file = ./jobo_bot.age;

  programs = {
    bash = {
      interactiveShellInit = ''
        if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
          tmux attach-session -t ${hostname} || tmux new-session -s ${hostname}
        fi
      '';
    };
    vim.defaultEditor = true;
  };

  custom = {
    stateVersion = "21.11";
    base.tmux.color = "#ee00aa";
  };

}

