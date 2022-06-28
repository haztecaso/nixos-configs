{ config, pkgs, ... }:
{
  config = lib.mkIf config.custom.desktop.enable {
    programs.zathura = {
      enable = true;
      options = {
        guioptions = "";
        zoom-step = 5;
        zoom-max = 2000;
        window-title-basename = true;
        show-hidden = 1;
        page-padding = 2;
        default-bg = "#000000";
        inputbar-bg = "#1c1c1c";
        inputbar-fg = "#ebdbb2";
        recolor-lightcolor = "#1c1c1c";
        recolor-keephue = true;
      };
      extraConfig = ''
        map i recolor
        map p print
        map b toggle_statusbar
        map f toggle_fullscreen
        map Down navigate next
        map Up navigate prev
      '';
    };
  };
}
