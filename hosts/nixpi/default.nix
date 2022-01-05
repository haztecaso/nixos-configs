{ config, pkgs, ... }: let
  hostname = "nixpi";
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./services/jobo_bot.nix
    ];

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

  users.users.skolem = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$6$IzsxtbrC5H9XoQTb$5pmicFaRBUfPSg26KSFV1B7ije86dszUM27gy9LF5ElgQLH/rl9GG5kyHnG.Co2vZ6LoGzZl7cJ8ZklzWnxjo1";    
  };

  environment.systemPackages = with pkgs; [ vim jobo_bot ];

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
  };

  programs = {
    bash = {
      interactiveShellInit = ''
        if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
          tmux attach-session -t ${hostname} || tmux new-session -s ${hostname}
        fi
      '';
    };
    tmux = {
      enable = true;
      statusColor = "#ee00aa";
    };
    vim = {
      enable = true;
      defaultEditor = true;
    };
  };

  system.stateVersion = "21.11";

}

