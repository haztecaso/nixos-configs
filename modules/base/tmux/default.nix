{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.custom.base.tmux;
  custom_conf = readFile ./tmux.conf;
in
{
  options.custom.base.tmux = {
    enable = mkEnableOption "custom tmux config";
    customConfig = mkOption {
      type = types.bool;
      default = true;
    };
    color = mkOption {
      type = types.str;
      default = "#00ee00";
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      tmux.extraConfig = ''
        ${if cfg.customConfig then custom_conf else ""}
        set -g pane-active-border-style fg="${cfg.color}"
        set -g status-left '#[fg="${cfg.color}"](#S) '
      '';
    };
  };
}
