{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
      luks.devices."root".device = "/dev/disk/by-uuid/0c432ee2-806a-4413-9513-d0191e552463";
    };

    kernelModules = [ "wl" ];
    extraModulePackages = [ ];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

  };


  fileSystems."/" = {
    # device = "/dev/disk/by-uuid/7d9fface-7cf1-4464-8137-0c9bd7ef5544";
    device = "/dev/mapper/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/15CC-2C93";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/48eab118-2d67-41da-846a-d9c6c49a37b7"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
