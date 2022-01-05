{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.programs.tmux;
  custom_conf = readFile ./tmux.conf;
in
{
  options.programs.tmux = {
    customConfig = mkOption {
      type = types.bool;
      default = true;
    };
    statusColor = mkOption {
      type = types.str;
      default = "#00ee00";
    };
  };

  config = mkIf cfg.enable {
    programs.tmux.extraConfig = ''
      ${if cfg.customConfig then custom_conf else ""}
      set -g pane-active-border-style fg="${cfg.statusColor}"
      set -g status-left '#[fg="${cfg.statusColor}"](#S) '
    '';
  };
}
