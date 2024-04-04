{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "kvm-intel" ];
      luks.devices."root".device = "/dev/disk/by-uuid/0496810a-4120-499a-a58c-f343a4900905";
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
    device = "/dev/disk/by-uuid/64E8-E4E5";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/effca83e-7bcc-4625-a8d9-cfe8b0cde0e9"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
