{ config, lib, pkgs, ... }:
let
  home-config = {
    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "x-scheme-handler/magnet" = "transmission-gtk.desktop";
        "x-scheme-handler/tg" = "telegramdesktop.desktop";
        "application/pdf"="org.pwmt.zathura.desktop";
        "audio/flac"="mpv.desktop";
      };
      defaultApplications = {
        "x-scheme-handler/magnet" = "transmission-gtk.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "audio/flac" = "mpv.desktop";
        "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
        "text/html" = "org.qutebrowser.qutebrowser.desktop";
        "image/gif" = "sxiv.desktop";
        "image/jpeg" = "sxiv.desktop";
        "image/png" = "sxiv.desktop";
        "image/tiff" = "sxiv.desktop";
        "application/x-bzip" = "xarchiver.desktop";
        "application/x-bzip2" = "xarchiver.desktop";
        "application/zip" = "xarchiver.desktop";
        "application/gzip" = "xarchiver.desktop";
        "application/x-7z-compressed" = "xarchiver.desktop";
        "application/x-tar" = "xarchiver.desktop";
      };
    };
  };
in
{
  imports = [
    ./latex
    ./nnn
    ./irssi
    ./ranger
    ./shells
    ./tmux
    ./vim
  ];
  home-manager.users.skolem = { ... }: home-config;
  home-manager.users.root   = { ... }: home-config;
}
