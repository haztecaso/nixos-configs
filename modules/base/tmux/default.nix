{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.custom.base.tmux;
in
{
  options.custom.base.tmux = {
    customConfig = mkOption {
      type = types.bool;
      default = true;
    };
    color = mkOption {
      type = types.str;
      default = "#00ee00";
    };
  };

  config.home-manager.users = let
      config = {
        programs.tmux = {
          enable = true;
          extraConfig = ''
            ${if cfg.customConfig then (readFile ./tmux.conf) else ""}
            set -g pane-active-border-style fg="${cfg.color}"
            set -g status-left '#[fg="${cfg.color}"](#S) '
          '';
        };
      };
    in {
      skolem = { ... }: config;
      root = { ... }: config;
    };

}
