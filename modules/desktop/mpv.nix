# TODO: install scripts!
#       - autocrop
#       - autosub
#       - equalizer
{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
        mpris
        thumbnail
        # youtube-quality
    ];
    config = {
      geometry = "50%x50%";
      autofit-larger = "85%x85%";
      keep-open = "yes";
      osc = "no";
      ontop = "no";
      slang = "es,en,it,pt";
      alang = "es,en,it,pt";
      "save-position-on-quit" = "";
    };
    bindings = {
      l = "seek 5";
      h = "seek -5";
      k = "add volume 2";
      j = "add volume -2";
      d = "ignore";
      V = "ignore";
      "Alt+-" = "add video-zoom -0.25";
      "Alt++" = "add video-zoom 0.25";
      "Alt+h" = "add video-pan-x 0.05";
      "Alt+l" = "add video-pan-x -0.05";
      "Alt+k" = "add video-pan-y 0.05";
      "Alt+j" = "add video-pan-y -0.05";
    };
  };
}
