final: prev: {
  autofirma = prev.callPackage ./autofirma.nix {};

  battery_level = prev.callPackage ({ pkgs, ... }: pkgs.writeScriptBin "battery_level" ''
    #!${pkgs.runtimeShell}
    now=$(cat /sys/class/power_supply/$1/charge_now)
    full=$(cat /sys/class/power_supply/$1/charge_full_design)
    echo "scale=0 ; 100 * $now / $full" | ${pkgs.bc}/bin/bc
  '') {};

  bitwarden-rofi = prev.callPackage (import (builtins.fetchGit {
    url = "https://github.com/haztecaso/bitwarden-rofi";
    ref = "main";
    rev = "b252037ca6fd3dff4d92a2f8068f91a7049749c9";
  })) {};

  configuradorfmnt = prev.callPackage ./configuradorfmnt.nix {};
}
