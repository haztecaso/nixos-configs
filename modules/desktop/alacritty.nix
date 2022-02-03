{ config, pkgs, ... }:
let
  font_family = "Liberation mono";
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      window.padding.x = 6;
      window.padding.y = 6;
      
      scrolling.multiplier = 3;
      scrolling.history = 10000;

      font = {
        size = 10;
        normal.family = font_family;
        normal.style = "Regular";
        bold.family = font_family;
        bold.style = "Bold";
        italic.family = font_family;
        italic.style = "Italic";
        bold_italic.family = font_family;
        bold_italic.style = "Bold Italic";
      };

      key_bindings = [
        { key = "K"; mods = "Control|Alt"; action = "IncreaseFontSize"; }
        { key = "J"; mods = "Control|Alt"; action = "DecreaseFontSize"; }
      ];
      
      cursor.style = "Beam";
      cursor.vi_mode_style = "Block";

      colors = {
        primary = {
          background = "#1d2021";
          foreground= "#ebdbb2";
        };
        normal = {
          black=   "#282828";
          red=     "#cc241d";
          green=   "#98971a";
          yellow=  "#d79921";
          blue=    "#458588";
          magenta= "#b16286";
          cyan=    "#689d6a";
          white=   "#a89984";
        };
        bright = {
          black=   "#928374";
          red=     "#fb4934";
          green=   "#b8bb26";
          yellow=  "#fabd2f";
          blue=    "#83a598";
          magenta= "#d3869b";
          cyan=    "#8ec07c";
          white=   "#ebdbb2";
        };
      };
    };
  };

  home.sessionVariables = {
    TERMINAL = "alacritty";
  };
}
