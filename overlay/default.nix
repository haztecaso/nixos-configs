final: prev: {
  deploy = prev.callPackage ./deploy.nix {};
  autofirma = prev.callPackage ./autofirma.nix {};

  battery_level = prev.callPackage ./battery_level.nix {};

  bitwarden-rofi = prev.callPackage (import (builtins.fetchGit {
    url = "https://github.com/haztecaso/bitwarden-rofi";
    ref = "main";
    rev = "b252037ca6fd3dff4d92a2f8068f91a7049749c9";
  })) {};

  configuradorfmnt = prev.callPackage ./configuradorfmnt.nix {};

  dmenu_mpd = prev.callPackage ./dmenu_mpd.nix {};

  dmenu_run_history = prev.callPackage ./dmenu_run_history.nix {};

  dnsblock = prev.callPackage ./dnsblock.nix {};

  message = prev.callPackage ./message.nix {};

  uni-cd = prev.callPackage ./uni-cd.nix {};

  uni-schedule = prev.callPackage ./uni-schedule.nix {};
}
