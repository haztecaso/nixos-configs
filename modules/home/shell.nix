{ lib, pkgs, config, nixosConfig, ... }:
with lib;
let
  cfg = config.custom.shell;
  hostname = nixosConfig.base.hostname;
  hostnameSymbol = nixosConfig.base.hostnameSymbol;
  shortcut_aliases = config.custom.shortcuts.aliases;
in
{
  options.custom.shell = {
    aliases = mkOption {
      type = types.attrsOf types.str;
      description = "Shell aliases.";
      default = {
        ".." = "cd ..";
        less = "less --quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4";
        cp = "cp -i";
      };
      example = true;
    };
    defaultShell = mkOption {
      type = types.package;
      description = "Default shell. For now only bash is working as intended.";
      default = pkgs.bash; # TODO: bash for now, until I discover how to prolerly set EDITOR and VISUAL variables on zsh...
    };
    initExtra = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of extra lines for init file";
    };
  };

  config = {
    programs = {
      bash = {
        enable = true;
        shellAliases = cfg.aliases // shortcut_aliases;
        initExtra = ''
          export PS1="\[\e[00;34m\][\u@${hostnameSymbol}:\w]\\$ \[\e[0m\]"
          if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
            tmux attach-session -t ${hostname} || tmux new-session -s ${hostname}
          fi
          ${lib.concatStrings cfg.initExtra}
        '';
      };
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        enableSyntaxHighlighting = true;
        autocd = true;
        dotDir = ".config/zsh";
        history.path = "${config.xdg.dataHome}/zsh/zsh_history";
        prezto = {
          enable = true;
          editor.keymap = "vi";
          historySubstring.foundColor = "fg=blue";
          historySubstring.notFoundColor = "fg=red";
          tmux.autoStartRemote = true;
          tmux.defaultSessionName = hostname;
          utility.safeOps = true;
        };
        shellAliases = cfg.aliases // shortcut_aliases;
      };
    };
  };
}
