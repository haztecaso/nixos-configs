{ config, pkgs, ... }: let
  keys = import ../../ssh-keys.nix;
in
{
  imports = [ ./hardware.nix ];

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
    interfaces.eth0.useDHCP = true;
    firewall.allowedTCPPorts = [ 22 ];
  };

  environment.systemPackages = with pkgs; [ jobo_bot ];

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
    };
    vim.defaultEditor = true;
  };

  custom = {
    stateVersion = "21.11";
    base = {
      hostname = "nixpi";
      tmux.color = "#ee00aa";
    }
  };

}

