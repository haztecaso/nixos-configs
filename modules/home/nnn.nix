{ lib, pkgs, config, inputs, ... }:
let
  cfg = config.custom.programs.nnn;
in
  {
    options.custom.programs.nnn = with lib; {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable custom nnn config with shortcuts";
      };

      bookmarks = mkOption {
        type = with types; attrsOf str;
        description = "Directory bookmarks.";
        default = {
          d = "~/Documents";
          D = "~/Downloads";
          p = "~/Pictures";
          h = "~";
          c = "~/.config";
          m = "~/Music";
          v = "~/Videos";
        };
      };
    };

    config = lib.mkIf cfg.enable {
      programs = {
        nnn = {
          enable = true;
          package = pkgs.nnn.override ({ withNerdIcons = true; });
          extraPackages = with pkgs; [ tabbed sxiv ];
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
      # shells = {
      #   initExtra = [
      #     ''
      #       export NNN_OPTS="aRe"
      #     ''
      #   ];
      #   aliases = {
      #     r = "nnn";
      #     nn = "nnn";
      #   };
      # };
    };
  };
}
