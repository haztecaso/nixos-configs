{ config, ... }: {
  imports = [
    ./base.nix
    ./desktop
    ./dev.nix
    ./home
    ./monitors.nix
    ./services
    ./shortcuts
    ./webserver
  ];

  custom.services.tailscale.hosts =
    let
      localNames = name: [ name "${name}.lan" "${name}.local" ];
    in
    {
      "100.84.40.96" = (localNames "lambda") ++ (localNames "netdata.lambda");
      "100.75.165.118" = localNames "beta";
      "100.70.238.47" = localNames "realme8";
      "100.84.161.27" = localNames "galois";
      "100.93.219.95" = (localNames "rpi") ++ (localNames "rpi-mpd") ++ (localNames "raspi-music") ++ [ "semuta.mooo.com" ];
    };
}
