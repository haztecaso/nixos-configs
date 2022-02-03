final: prev: {
  deploy = prev.callPackage ./deploy.nix {};
  autofirma = super.callPackage ./autofirma.nix {};

  battery_level = super.callPackage ./battery_level.nix {};

  bitwarden-rofi = super.callPackage (import (builtins.fetchGit {
    url = "https://github.com/haztecaso/bitwarden-rofi";
    ref = "main";
    rev = "b252037ca6fd3dff4d92a2f8068f91a7049749c9";
  })) {};

  configuradorfmnt = super.callPackage ./configuradorfmnt.nix {};

  dmenu_mpd = super.callPackage ./dmenu_mpd.nix {};

  dmenu_run_history = super.callPackage ./dmenu_run_history.nix {};

  dnsblock = super.callPackage ./dnsblock.nix {};

  message = super.callPackage ./message.nix {};

  uni-cd = super.callPackage ./uni-cd.nix {};

  uni-schedule = super.callPackage ./uni-schedule.nix {};
}
