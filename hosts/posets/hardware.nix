{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "kvm-intel" ];
      luks.devices."root".device = "/dev/disk/by-uuid/4a76f756-9057-40fa-9f43-214174b5cbe8";
    };

    kernelModules = [ "wl" ];
    extraModulePackages = [ ];

    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
      };
      timeout = 1;
      efi.canTouchEfiVariables = true;
    };
  };


  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3795-C76E";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/58c494f1-73bb-42fa-b031-6ecb15542b7c"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
