{ lib,  config, ... }:
let
  cfg = config.custom.programs.irssi;
in
  {
    options.custom.programs.irssi = with lib; {
      enable = mkEnableOption "Enable irssi irc client.";
      nick = mkOption {
        type = types.str;
        default = "tarski";
        description = "irc nick";
      };
    };

    config = lib.mkIf cfg.enable {
      programs = {
        irssi = {
          enable = true;
          networks = {
            liberachat = {
              nick = cfg.nick;
              autoCommands = [
                "/msg "
              ];
              server = {
                address = "irc.libera.chat";
                port = 6697;
                ssl.enable = true;
                # autoConnect = true;
              };
              channels = {
                nixos.autoJoin = true;
              };
            };
            # irchighway = {
            #   nick = cfg.nick;
            #   server = {
            #     address = "irc.irchighway.net";
            #     port = 7000;
            #     ssl.enable = false;
            #     autoConnect = true;
            #   };
            #   channels = {
            #     ebooks.autoJoin = true;
            #   };
            # };
          };
        };
      };
      custom.shell.aliases.irc = "irssi";
    };
  }
