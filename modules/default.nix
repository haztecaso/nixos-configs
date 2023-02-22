{ config, ... }: {
  imports = [
    ./base.nix
    ./desktop
    ./dev.nix
    ./home
    ./monitors.nix
    ./services
  ];
}
