{ config, lib, ... }:
let
  stateVersionModule = { nixosConfig, ... }: {
    home.stateVersion = nixosConfig.base.stateVersion;
  };
in
{
  home-manager = {
    extraSpecialArgs = { nixosConfig = config; };
    useGlobalPkgs = true;
    sharedModules = [
      stateVersionModule
      {
        imports = [
          ./desktop
          ./git.nix
          ./irssi.nix
          ./latex.nix
          ./mail.nix
          ./money.nix
          ./monitors.nix
          ./music.nix
          ./nnn.nix
          ./ssh.nix
          ./tmux.nix
          ./vim.nix
        ];
        programs = {
          gpg.enable = true;
        };
        services = {
          gpg-agent.enable = true;
        };
        xdg.mimeApps = {
          enable = true;
          associations.added = {
            "x-scheme-handler/magnet" = "transmission-gtk.desktop";
            "x-scheme-handler/tg" = "telegramdesktop.desktop";
            "application/pdf" = "org.pwmt.zathura.desktop";
            "audio/flac" = "mpv.desktop";
          };
          defaultApplications = {
            "x-scheme-handler/magnet" = "transmission-gtk.desktop";
            "application/pdf" = "org.pwmt.zathura.desktop";
            "audio/flac" = "mpv.desktop";
            "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
            "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
            "x-scheme-handler/chrome" = "org.qutebrowser.qutebrowser.desktop";
            "application/x-extension-htm" = "org.qutebrowser.qutebrowser.desktop";
            "application/x-extension-html" = "org.qutebrowser.qutebrowser.desktop";
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
      }
    ];
  };

  # Create users for home-manager configs
  users.users =
    lib.mapAttrs (_: _: { isNormalUser = true; })
      (lib.filterAttrs (name: _: name != "root")
        config.home-manager.users);
}
