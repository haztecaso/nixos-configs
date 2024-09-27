self: super: {
  autofirma = super.callPackage ./autofirma.nix { };

  battery_level = super.callPackage
    ({ pkgs, ... }: pkgs.writeScriptBin "battery_level" ''
      #!${pkgs.runtimeShell}
      now=$(cat /sys/class/power_supply/$1/charge_now)
      full=$(cat /sys/class/power_supply/$1/charge_full_design)
      echo "scale=0 ; 100 * $now / $full" | ${pkgs.bc}/bin/bc
    '')
    { };

  moodle-dl-new = super.callPackage ./moodle-dl { };

  configuradorfmnt = super.callPackage ./configuradorfmnt.nix { };

  logseq = super.logseq.override {
    electron = super.electron_27;
  };

}
