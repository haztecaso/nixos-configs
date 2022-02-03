{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
    };
    kernelModules = [ "wl" ];
    extraModulePackages = [ ];

    loader.grub = {
      efiSupport = true;
      device = "/dev/disk/by-uuid/1967-68D4";
    };

  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0e047142-e415-445d-a3a0-39f2ab2a8f4a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1967-68D4";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/29439436-30ae-4ff3-aa45-8f200ba7be08"; } ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
