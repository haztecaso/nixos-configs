{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.ranger;
  filterNonNull = builtins.filter (x: x != null);
  mkShortcutMaps = name: path: map (a: "map " + a.prefix + name + " " + a.cmd + " " + path) cfg.actions;
  shortcuts = with lib; concatStringsSep "\n" (
    concatLists (
      attrValues (
        mapAttrs mkShortcutMaps config.custom.shortcuts.paths
      )
    )
  );

in
{
  options.custom.programs.ranger = with lib; {
    enable = mkEnableOption "Enable custom ranger config with shortcuts";
    actions = mkOption {
      type = types.listOf (types.attrsOf types.str);
      default = [
        { prefix = "g"; cmd = "cd"; }
        { prefix = "t"; cmd = "tab_new"; }
        { prefix = "m"; cmd = "shell mv -v %s"; }
        { prefix = "Y"; cmd = "shell cp -tv %s"; }
      ];
      description = "Actions for shortcuts.";
    };
    extraOptions = mkOption {
      type = types.str;
      default = "";
      description = "Extra ranger options";
    };
    extraRifle = mkOption {
      type = types.str;
      default = "";
      description = "Extra ranger rifle.conf options";
    };
    enablePreview = mkEnableOption "wether to enable multiple preview methods";
  };

  config = lib.mkIf cfg.enable {
    custom.programs.ranger.enablePreview = lib.mkDefault config.custom.desktop.enable;
    home = {
      packages = with pkgs; filterNonNull [
        ranger 
        (if cfg.enablePreview then _7zz else null)
        (if cfg.enablePreview then atool else null)
        (if cfg.enablePreview then odt2txt else null)
        (if cfg.enablePreview then imagemagick else null)
        (if cfg.enablePreview then ffmpegthumbnailer else null)
        (if cfg.enablePreview then poppler_utils else null)
        (if cfg.enablePreview then ueberzug else null)
      ];
      sessionVariables."RANGER_LOAD_DEFAULT_RC" = "FALSE";
    };
    xdg.configFile = {
      "ranger/rc.conf".text = ''
        ${builtins.readFile ./rc.conf}
        # Commands defined by nix configuration
        ${shortcuts}

        # Extra config defined by nix configuration
        ${cfg.extraOptions}
      '';
      "ranger/rifle.conf".text = ''
        ${builtins.readFile ./rifle.conf}

        # Extra config defined by nix configuration
        ${cfg.extraRifle}
      '';
      "ranger/scope.sh" = {
        executable = true;
        source = ./scope.sh;
      };
    };
    custom.shell.aliases.r = "ranger";
  };
}
