{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e4c1f462-6a3d-4720-b919-e89a30791639";
      fsType = "ext4";
    };

  swapDevices = [ { device = "/swapfile"; size=1024; } ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
