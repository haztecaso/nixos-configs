{ ... }: {
  imports = [
    ./base.nix
    ./desktop
    ./dev.nix
    ./programs
    ./services
    ./shortcuts
    ./webserver
  ];
}
