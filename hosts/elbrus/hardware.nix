{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
      luks.devices."root".device = "/dev/disk/by-uuid/941231a1-cfad-40c7-a2ea-0cbcba781ee2";
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
    device = "/dev/disk/by-uuid/9B95-F0B7";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/632db255-52bf-4c8c-b4da-30b29bb25a7c"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
