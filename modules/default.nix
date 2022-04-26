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

  shortcuts = {
    paths = {
      D = "~/Downloads";
      cf = "~/.config";
      d = "~/Documents";
      h = "~";
      mm = "~/Music";
      n = "~/nixos-configs";
      pp = "~/Pictures";
      sr = "~/src";
      vv = "~/Videos";
    };
    uni.asignaturas = [ "tpro" "gcomp" "afvc" "topo" ];
  };

  programs = {
    shells.aliases = {
      ".." = "cd ..";
      less = "less --quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4";
      cp = "cp -i";
    };
  };

  custom.programs.nnn.bookmarks = {
    D = "~/Downloads";
    c = "~/.config";
    h = "~";
    d = "~/Documents";
    n = "~/nixos-configs";
  };

  services.custom.tailscale.hosts =
    let
      localNames = name: [ name "${name}.lan" "${name}.local" ];
    in
    {
      "100.84.40.96" = (localNames "lambda") ++ (localNames "netdata.lambda");
      "100.75.165.118" = localNames "beta";
      "100.70.238.47" = localNames "realme8";
      "100.84.161.27" = localNames "galois";
      "100.93.219.95" = (localNames "raspi-music") ++ [ "semuta.mooo.com" ];
    };
}
