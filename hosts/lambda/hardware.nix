{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    loader.grub.device = "/dev/sda";
    initrd.kernelModules = [ "nvme" ];
  };

  fileSystems."/" = { device = "/dev/sda3"; fsType = "ext4"; };
}
