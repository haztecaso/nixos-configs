#TODO: improve module
{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.ssh;
  defaultConfig = ''
    Host github.com
        User git
        Hostname github.com
        IdentityFile ~/.ssh/github

    Host rpi rpi-mpd raspi-config semuta.mooo.com
        User pi
    
    Host rpi-mpd
        RemoteCommand ncmpcpp
        RequestTTY yes
    
    Host lambda lambda.lan lambda.local
        User root
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

  config.home-manager.users =
    let
      config = {
        programs.ssh = {
          enable = true;
          extraConfig = ''
            ${if cfg.enableDefaultConfig then defaultConfig else ""}
            ${cfg.extraConfig}
          '';
        };
      };
    in
    lib.mkIf cfg.enable {
      skolem = { ... }: config;
      root = { ... }: config;
    };

}
