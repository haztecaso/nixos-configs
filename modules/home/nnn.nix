{ lib, pkgs, config, inputs, ... }:
let
  cfg = config.custom.programs.nnn;
in
{
  options.custom.programs.nnn = with lib; {
    enable = mkEnableOption  "Enable custom nnn config with shortcuts";

    bookmarks = mkOption {
      type = with types; attrsOf str;
      description = "Directory bookmarks.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nnn = {
        enable = true;
        package = pkgs.nnn.override { withNerdIcons = true; };
        extraPackages = with pkgs; [ sxiv ];
        plugins = {
          src = "${inputs.nnn}/plugins";
          mappings = {
            P = "preview-tabbed";
            f = "finder";
            p = "preview-tui";
            v = "imgview";
          };
        };
        bookmarks = cfg.bookmarks;
      };
    };
    custom = {
      shell = {
        initExtra = [''export NNN_OPTS="aRe"''];
        aliases.r = "nnn";
      };
      programs.nnn.bookmarks = with lib;{
        D = mkDefault "~/Downloads";
        c = mkDefault "~/.config";
        d = mkDefault "~/Documents";
        h = mkDefault "~";
        m = mkDefault "~/Music";
        p = mkDefault "~/Pictures";
        s = mkDefault "~/src";
        v = mkDefault "~/Videos";
      };
    };
  };
}
