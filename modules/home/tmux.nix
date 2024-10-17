{ lib,  config, ... }:
with lib;
let
  cfg = config.custom.programs.tmux;
in
{
  options.custom.programs.tmux = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable tmux.";
    };
    customConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Use custom config.";
    };
    color = mkOption {
      type = types.str;
      default = "#00ee00";
      description = "Color of tmux statusbar.";
    };
  };

  config = {
    programs.tmux = {
      enable = cfg.enable;
      extraConfig = ''
        ${if cfg.customConfig then (readFile ./tmux.conf) else ""}
        set -g pane-active-border-style fg="${cfg.color}"
        set -g status-left '#[fg="${cfg.color}"](#S) '
      '';
    };
  };

}
