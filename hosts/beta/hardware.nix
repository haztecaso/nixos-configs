{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd.availableKernelModules = [ "usbhid" ];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
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

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e4c1f462-6a3d-4720-b919-e89a30791639";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/swapfile"; size=1024; } ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
