{ lib, pkgs, config, inputs, ... }:
let
  cfg = config.custom.programs.irssi;
in
{
  options.custom.programs.irssi = with lib; {
    enable = mkEnableOption "Enable irssi irc client.";
  };

  config = lib.mkIf cfg.enable (let
    conf = {
      programs.irssi = {
        enable = true;
        networks = {
          liberachat = {
            nick = "skolem";
            server = {
              address = "irc.libera.chat";
              port = 6697;
              ssl.enable = true;
              autoConnect = true;
            };
            channels = {
              nixos.autoJoin = true;
            };
          };
          irchighway = {
            nick = "skolem";
            server = {
              address = "irc.irchighway.net";
              port = 6697;
              ssl.enable = true;
              autoConnect = true;
            };
            channels = {
              ebooks.autoJoin = true;
            };
          };
        };
      };
    };
  in {
    custom.programs.shells = {
      aliases = {
        irc  = "irssi";
      };
    };
    home-manager.users.skolem = { ... }: conf;
    home-manager.users.root   = { ... }: conf;
  });
}
