{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.ranger;
  includeDefault = file: builtins.readFile "${pkgs.ranger}/lib/python3.9/site-packages/ranger/config/${file}";
  mkShortcutMaps = name: path: map (a: "map "+a.prefix+name+" "+a.cmd+" "+path) cfg.actions;
  shortcuts = with lib; concatStringsSep "\n" (
    concatLists (
      attrValues (
        mapAttrs mkShortcutMaps config.shortcuts.paths
        )
      )
    );

in
{
  options.custom.programs.ranger = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable custom ranger config with shortcuts";
    };
    actions = mkOption {
      type = types.listOf (types.attrsOf types.str);
      default = [
        { prefix = "g"; cmd = "cd";}
        { prefix = "t"; cmd = "tab_new";}
        { prefix = "m"; cmd = "shell mv -v %s";}
        { prefix = "Y"; cmd = "shell cp -tv %s";}
      ];
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
  };

  config = lib.mkIf cfg.enable (let
    conf = {
      home.packages = [ pkgs.ranger ];
      home.sessionVariables."RANGER_LOAD_DEFAULT_RC" = "FALSE";
      xdg.configFile = {
        "ranger/rc.conf".text =
          ''
            ${includeDefault "rc.conf"}
            # Commands defined by nix configuration
            ${shortcuts}
      
            # Extra config defined by nix configuration
            ${cfg.extraOptions}
          '';
        "ranger/rifle.conf".text =
          ''
            ${includeDefault "rifle.conf"}
            # Extra config defined by nix configuration
            ${cfg.extraRifle}
          '';
      };
    };
  in {
    custom.programs.shells = {
      aliases = {
        r  = "ranger";
        nn = "ranger";
      };
    };
    home-manager.users.skolem = { ... }: conf;
    home-manager.users.root   = { ... }: conf;
  });
}
