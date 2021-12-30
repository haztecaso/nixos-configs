{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.programs.tmux;
in
{
  options.programs.tmux = {
    customPaneNavigationAndResizeMeta = mkOption {
      type = types.bool;
      default = true;
    };
    fullScreenBinding = {
      type = types.str;
      default = "M-o";
    };
  };

  config = mkIf cfg.enable {
    programs.tmux.extraConfig = ''
      ${if cfg.customPaneNavigationAndResizeMeta then ''
        bind -n M-h select-pane -L
        bind -n M-j select-pane -D
        bind -n M-k select-pane -U
        bind -n M-l select-pane -R
        bind -n M-J resize-pane -D 3
        bind -n M-K resize-pane -U 3
        bind -n M-H resize-pane -L 7
        bind -n M-L resize-pane -R 7
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        bind J resize-pane -D 3
        bind K resize-pane -U 3
        bind H resize-pane -L 7
        bind L resize-pane -R 7
      '' else ""}
    bind -n ${cfg.fullScreenBinding} resize-pane -Z
    '';
  };
}
