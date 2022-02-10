{ lib, pkgs, config, ... }:
# TODO: Allow per-user configs
with lib;
let
  cfg = config.custom.base.shells;
in
{
  options.custom.base.shells = {
    aliases = mkOption {
      type = types.attrsOf types.string;
      default = {
        ".." = "cd ..";
        less = "less --quit-if-one-screen --ignore-case --status-column--LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4";
        vim = "nvim";
        r = "ranger";
        cp = "cp -i";
        ytd = "youtube-dl";
      };
      example = true;
    };
    defaultShell = mkOption {
      type = types.package;
      default = pkgs.zsh;
    };
  };

  config = let
      conf = home-conf: {
        programs.bash = {
          enable = true;
          shellAliases = cfg.aliases // config.custom.shortcuts.aliases;
          initExtra = ''
            export PS1="\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\]\[$(tput sgr0)\]"
            if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
              tmux attach-session -t ${config.custom.base.hostname} || tmux new-session -s ${config.custom.base.hostname}
            fi
          '';
        };

        programs.zsh = {
          enable = true;
          enableAutosuggestions = true;
          enableCompletion = true;
          enableSyntaxHighlighting = true;
          autocd = true;
          dotDir = ".config/zsh";
          history.path = "${home-conf.xdg.dataHome}/zsh/zsh_history";
          prezto = {
            enable = true;
            editor.keymap = "vi";
            historySubstring.foundColor = "fg=blue";
            historySubstring.notFoundColor = "fg=red";
            tmux.autoStartRemote = true;
            tmux.defaultSessionName = config.custom.base.hostname;
            utility.safeOps = true;
          };
          shellAliases = cfg.aliases // config.custom.shortcuts.aliases;
        };
      };
  in

  {
    environment.pathsToLink = [ "/share/zsh" ];
    home-manager.users = {
      skolem = { config, ... }: conf config;
      root = { config, ... }: conf config;
    };
    users.users = {
      skolem.shell = cfg.defaultShell;
      root.shell   = cfg.defaultShell;
    };
  };
}
