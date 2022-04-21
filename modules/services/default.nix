{ ... }:
{
  imports = [
    ./code.nix
    ./gitea.nix
    ./netdata.nix
    ./syncthing.nix
    ./tailscale.nix
    ./vaultwarden.nix
  ];
}
