final: prev: {
  autofirma = prev.callPackage ./autofirma.nix { };

  battery_level = prev.callPackage
    ({ pkgs, ... }: pkgs.writeScriptBin "battery_level" ''
      #!${pkgs.runtimeShell}
      now=$(cat /sys/class/power_supply/$1/charge_now)
      full=$(cat /sys/class/power_supply/$1/charge_full_design)
      echo "scale=0 ; 100 * $now / $full" | ${pkgs.bc}/bin/bc
    '')
    { };

  moodle-dl-new = prev.callPackage ./moodle-dl { };

  configuradorfmnt = prev.callPackage ./configuradorfmnt.nix { };

}
