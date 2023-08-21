{ config, ... }: {
  imports = [
    ./base.nix
    ./desktop
    ./mesh.nix
    ./dev.nix
    ./home
    ./monitors.nix
    ./services
  ];
}
