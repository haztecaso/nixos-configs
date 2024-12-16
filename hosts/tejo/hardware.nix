{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
      luks.devices."root".device = "/dev/disk/by-uuid/d38b5b7a-57b3-4d1e-ac24-61444962f22c";
    };

    kernelModules = [ "wl" "kvm-intel" ];
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
    device = "/dev/disk/by-uuid/AAE5-5206";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/13cc0401-0660-49bc-89bd-222fac19ea2c"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
