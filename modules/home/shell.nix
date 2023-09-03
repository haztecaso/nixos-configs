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
    };
    defaultShell = mkOption {
      type = types.package;
      description = "Default shell. For now only bash is working as intended.";
      default = pkgs.zsh;
    };
    initExtra = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of extra lines for init file";
    };
  };

  config = {
    custom.shell = {
      aliases = {
        ".." = lib.mkDefault "cd ..";
        less = lib.mkDefault "less --quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4";
        cp = lib.mkDefault "cp -i";
      };
    };
    programs = {
      bash = {
        enable = true;
        shellAliases = cfg.aliases // shortcut_aliases;
        initExtra = ''
          export PS1="\[\e[00;34m\][\u@${hostnameSymbol}:\w]\\$ \[\e[0m\]"
          if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
            tmux attach-session -t ${hostname} || tmux new-session -s ${hostname}
          fi
          ${if nixosConfig.custom.dev.direnv.enable then "
            eval \"$(direnv hook bash)\"
          " else ""}
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
        history = {
          save = 100000;
          size = 100000;
          path = "${config.xdg.dataHome}/zsh/zsh_history";
        };
        dirHashes = config.custom.shortcuts.paths;
        prezto = {
          enable = true;
          editor.keymap = "vi";
          historySubstring.foundColor = "fg=blue";
          historySubstring.notFoundColor = "fg=red";
          # tmux.autoStartRemote = true; #TODO: fix
          tmux.defaultSessionName = hostname;
          utility.safeOps = true;
        };
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "sudo" ];
        };
        plugins = [
          {
            name = "fzf-zsh-plugin";
            file = "fzf-zsh-plugin.plugin.zsh";
            src = builtins.fetchGit {
              url = "https://github.com/unixorn/fzf-zsh-plugin";
              ref = "main";
              rev = "5be9ab11845bc3c797706cbba929e2bc9a807020";
            };
          }
        ];
        shellAliases = cfg.aliases // shortcut_aliases;
        initExtra = ''
          ${if nixosConfig.custom.dev.direnv.enable then "
            eval \"$(direnv hook zsh)\"
          " else ""}
          if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
            tmux attach-session -t ${hostname} || tmux new-session -s ${hostname}
          fi
        '';
      };
      fzf = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
        fileWidgetOptions = [ "--preview 'head -200 {}'" ];
      };
    };
  };
}
