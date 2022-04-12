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
}
