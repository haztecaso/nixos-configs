{ config, lib, pkgs, ... }:
let
  cfg = config.custom.mail;
in {
  options.custom.mail = with lib; {
    enable = mkEnableOption "mail";
    accounts = mkOption {
      type = types.attrsOf (types.attrsOf (types.either types.str types.bool));
      example = {
        gmail = {
          primary = true;
          address = "me@gmail.com";
          imapAddress = "imap.gmail.com";
          smtpAddress = "smtp.gmail.com";
        };
      };
    };
    filters = mkOption {
      type = types.attrsOf (types.listOf types.str);
      example = {
        family = [ "mum@gmail.com" "dad@gmail.com" ];
        spam = [ "spam@gmail.com" ];
      };
    };
  };
  config = lib.mkIf cfg.enable {
    mbsync.enable = true; # Download mails with imap
    msmtp.enable = true;  # Send mails

    # CLI mail client
    alot = {
      enable = true;
      settings = {
        auto_remove_unread = true;
        initial_command = "search tag:inbox AND NOT tag:killed AND NOT tag:spam";
        prefer_plaintext = true;
      };
      # tags = { flagged.normal = "light red"; };
      bindings = {
        global = {
          q = "bclose";
          Q = "exit";
          r = "refresh";
          "/" = "prompt 'search '";
        };
        search = {
          s = "";
          S = "toggletags spam";
          u = "toggletags unread";
          K = "toggletags killed";
        };
      };
    };
  };
}
