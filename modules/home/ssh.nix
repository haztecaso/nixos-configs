#TODO: improve module
{ lib, pkgs, config, nixosConfig, ... }:
let
  cfg = config.custom.programs.ssh;
  tailscaleConfig = nixosConfig.custom.services.tailscale;
  mkConfig = with lib; ip: hostnames: ''
    Host ${concatStrings (intersperse " " hostnames)}
        Hostname ${ip}
  '';
  defaultConfig = ''
    Host github.com
        User git
        Hostname github.com
  '';
in
{
  options.custom.programs.ssh = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Wether to enable ssh client and configs.";
    };
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra ssh configs.";
    };
    enableDefaultConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Wether to enable common ssh configs.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      custom.programs.ssh.extraConfig = with lib;
        concatStrings (intersperse "\n" (mapAttrsToList mkConfig tailscaleConfig.hosts));
      programs.ssh = {
        enable = true;
        extraConfig = ''
          ${if cfg.enableDefaultConfig then defaultConfig else ""}
          ${cfg.extraConfig}
        '';
      };
    })
  ];
}
