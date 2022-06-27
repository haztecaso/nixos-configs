# Idea for mail deletion: https://blog.tomecek.net/post/removing-messages-with-notmuch/

{ config, lib, pkgs, ... }:
let
  cfg = config.custom.mail;
  mkConfig = name: { address, imapAddress, smtpAddress, primary ? false }: {
    inherit address primary;
    realName = "Adrián Lattes Grassi";
    userName = address;

    passwordCommand = "${pkgs.pass}/bin/pass show mails/${address}";

    imap = { host = imapAddress; port = 993; };
    smtp = { host = imapAddress; port = 465; };

    mbsync = { enable = true; create = "maildir"; };

    imapnotify = {
      enable = true;
      boxes = ["Inbox" "Sent" "Drafts"];
      onNotify = "${pkgs.isync}/bin/mbsync -q ${name}; ${pkgs.notmuch}/bin/notmuch new";
      onNotifyPost = "${pkgs.dunst}/bin/dunstify -r 1003 'New mail' '${name}'";
    };

    mbsync.extraConfig.account.PipelineDepth = 10;
    msmtp.enable = true;
    notmuch.enable = true;
    astroid.enable = true;
  };
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
    accounts.email.accounts = lib.mapAttrs mkConfig cfg.accounts;
    home.packages = with pkgs; [ pass ];
    programs = {
      mbsync.enable = true; # Download mails with imap
      msmtp.enable = true;  # Send mails
      password-store.enable = true;

      # Tag and search mails
      notmuch = {
        enable = true;
        maildir.synchronizeFlags = true;
        new.tags = [ "new" ];
        hooks.postNew = "${pkgs.afew}/bin/afew -tnv";
      };

      # notmuch autotagging and filters
      afew = {
        enable = true;
        extraConfig =
          # ${filters}
          ''
            [SpamFilter]
            [KillThreadsFilter]
            [ListMailsFilter]
            [ArchiveSentMailsFilter]
            [InboxFilter]
          '';
        };

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

      # mailcap for alot
      home.file.".mailcap".text = ''
        text/plain; cat %s
        text/html; ${pkgs.w3m}/bin/w3m -dump -o document_charset=%{charset} '%s'; nametemplate=%s.html; copiousoutput
        video/mp4; ${pkgs.mpv}/bin/mpv %s
        application/pdf; zathura %s
        application/pdf:pdf; zathura %s
        image/*; sxiv %s
      '';

    };
  };
}
