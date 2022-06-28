{ config, pkgs, lib, ... }:
let
  cfg = config.custom.desktop.alacritty;
in
{
  options.custom.desktop.alacritty = with lib; {
    fontFamily = mkOption {
      type = types.str;
      default = "Liberation mono";
      description = "Alacritty font name.";
    };
  };
  config = lib.mkIf config.custom.desktop.enable {
    home.sessionVariables.TERMINAL = "alacritty";
    programs.alacritty = {
      enable = true;
      settings = {
        window.padding = { x = 6; y = 6; };
        scrolling = { multiplier = 3; history = 10000; };
 
        font = {
          size = config.custom.desktop.fontSize;
          normal = { family = cfg.fontFamily; style = "Regular"; };
          bold = { family = cfg.fontFamily; style = "Bold"; };
          italic = { family = cfg.fontFamily; style = "Italic"; };
          bold_italic = { family = cfg.fontFamily; style = "Bold Italic"; };
        };
 
        key_bindings = [
          { key = "K"; mods = "Control|Alt"; action = "IncreaseFontSize"; }
          { key = "J"; mods = "Control|Alt"; action = "DecreaseFontSize"; }
          { key = "Return"; mods = "Control|Shift"; action = "SpawnNewInstance"; }
        ];
 
        cursor = { style = "Beam"; vi_mode_style = "Block"; };
 
        mouse.hide_when_typing = true;
 
        colors = {
          primary = {
            background = "#1d2021";
            foreground = "#ebdbb2";
          };
          normal = {
            black = "#282828";
            red = "#cc241d";
            green = "#98971a";
            yellow = "#d79921";
            blue = "#458588";
            magenta = "#b16286";
            cyan = "#689d6a";
            white = "#a89984";
          };
          bright = {
            black = "#928374";
            red = "#fb4934";
            green = "#b8bb26";
            yellow = "#fabd2f";
            blue = "#83a598";
            magenta = "#d3869b";
            cyan = "#8ec07c";
            white = "#ebdbb2";
          };
        };
      };
    };
  };
}
