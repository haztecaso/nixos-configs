{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      luks.devices.root = {
        device = "/dev/disk/by-uuid/ff6e50b3-b52f-437e-9315-12509787c79e";
        # keyFile = "/dev/disk/by-uuid/961479a6-2b16-4815-b63e-c0220d12d84c";
        # keyFileOffset = 1008730111;  
        # keyFileSize = 4096;
        # fallbackToPassword = true;
      };
      availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "firewire_ohci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sdhci_pci"
      ];
      kernelModules = [ ];
    };
    loader = {
      grub = {
        enable                = true;
        copyKernels           = true;
        devices               = [ "nodev" ];
        splashImage           = null;
        efiInstallAsRemovable = true;
        efiSupport = true;
        extraEntries = ''
          menuentry "Reboot" {
            reboot
          }
          menuentry "Poweroff" {
            halt
          }
        '';
      };
      timeout = 1;
    };
    cleanTmpDir = true;
    kernelModules = [ "kvm-intel" "wl" ];
    kernelParams = [
      "hid_apple.fnmode=1"
      "i915.fastboot=1"
      "sdhci.debug_quirks2=4"
    ];
    extraModprobeConfig = ''
      options snd_hda_intel index=0 model=intel-mac-auto id=PCH
      options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
      options snd_hda_intel model=mbp101
    '';
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/02383b7f-1048-47b1-a924-50853b3d9406";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/67E3-17ED";
      fsType = "vfat";
    };

  swapDevices = [ ];

  services.fstrim.enable = true;

  powerManagement.cpuFreqGovernor = "powersave";
  services.tlp.enable = true;
}
