{ config, lib, pkgs, ... }:
with lib;
let
  fst = list: elemAt list 0;

  mkShortcut = action:
    mapAttrs' (short: path:
      nameValuePair "${action.prefix}${short}" "${action.cmd} ${path}"
    );

  mkShortcuts = paths: actions:
    zipAttrsWith (n: v: fst v) (map (action: mkShortcut action paths) actions);

  cfg = config.custom.shortcuts;
in
{
  imports = [ ./uni.nix ];

  options.custom.shortcuts = {
    paths = mkOption {
      type = types.attrsOf types.str;
      default = {
        n = "/etc/nixos";
        d = "~/Documents";
        D = "~/Downloads";
        mm = "~/Music";
        pp = "~/Pictures";
        vv = "~/Videos";
        cf = "~/.config";
      };
      description = "Shortcuts to folders.";
    };
    actions = mkOption {
      type = types.listOf (types.attrsOf types.str);
      default = [
        { cmd = "cd"; prefix = ""; }
        { cmd = "nvim"; prefix = "v"; }
        { cmd = "ranger"; prefix = "r"; }
      ];
      description = "Actions of shortcuts.";
    };
    aliases = mkOption {
      readOnly = true;
      default = mkShortcuts cfg.paths cfg.actions;
      description = "Aliases generated from shortcuts.";
    };
  };
}
