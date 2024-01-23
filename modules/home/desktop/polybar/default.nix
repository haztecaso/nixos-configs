{ nixosConfig, config, lib, pkgs, ... }:
let
  cfg = config.custom.desktop.polybar;
  base = nixosConfig.base;
  wifi = lib.stringLength base.wlp.interface != 0;
  eth = lib.stringLength base.eth.interface != 0;
  batteryCombined = pkgs.writeScriptBin "battery-combined-udev" ''
    #!${pkgs.runtimeShell}
    ${builtins.readFile ./battery-combined-udev.sh}
  '';
in
{
  options.custom.desktop.polybar = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Wether to enable polybar";
    };
    batteryCombined = mkOption {
      type = types.bool;
      default = false;
      description = "Wether to enable custom module for displaying BAT0 and BAT1 combined";
    };
    bat = mkOption {
      type = types.str;
      example = "BAT0";
      description = "Battery device (value required if batteryCombined is set to false).";
    };
    mpd = mkEnableOption "polybar mpd module";
  };

  config = lib.mkIf config.custom.desktop.enable {
    services.polybar = {
      enable = true;
      package = pkgs.polybarFull;
      script = "polybar bar &";
      extraConfig = ''
        [bar/bar]
        enable-ipc = true
        monitor =

        top = true
        width = 100%
        height = 22
        radius = 0
        padding = 1

        background = $${color.bg}
        foreground = $${color.fg}
        dim-value = 1.0

        module-margin-left = 1
        module-margin-right = 2

        modules-left = ewmh
        modules-right = ${if cfg.mpd then "mpd " else ""}temp fs ${if wifi then
        "wifi " else ""}${if eth then "ethernet " else ""}${if cfg.batteryCombined then "bat-combined" else "bat"} vol date tray

        font-0 = "Literation Mono Nerd Font:size=10;2"
        font-1 = "Hack Nerd Font:size=8;2"

        [color]
        bg = #ee000000
        fg = #EAEAEA
        fg-alt = #9C9C9C

        [module/ewmh]
        type=internal/xworkspaces
        label-active="%name% "
        label-active-foreground=#00ff00
        label-urgent-foreground=#ff0000
        label-occupied="%name% "
        label-occupied-foreground=#999999
        label-empty="%name% "
        label-empty-foreground=#333333

        ${if cfg.mpd then ''[module/mpd]
        type = internal/mpd
        host = 127.0.0.1
        port = 6600

        format-online = <label-song>
        format-playing = <label-song> <icon-play>
        format-paused = <label-song> <icon-pause>
        format-stopped = <label-song> <icon-stop>

        icon-play = 
        icon-pause = 
        icon-stop = 
        '' else ""}
        [module/fs]
        type = internal/fs
        mount-0 = /
        interval = 10
        fixed-values = true
        label-mounted = %free%

        [module/temp]
        type = internal/temperature

        ${if wifi then ''
        [module/wifi]
        type = internal/network
        interface = ${base.wlp.interface}
        interval = 3
        label-connected = ${base.wlp.interface} %local_ip%
        '' else ""}
        ${if eth then ''
        [module/ethernet]
        type = internal/network
        interface = ${base.eth.interface}
        interval = 3
        label-connected = ${base.eth.interface} %local_ip%
        '' else ""}
        [module/vol]
        type = internal/pulseaudio
        interval = 1
        format-volume = <ramp-volume> <label-volume>
        label-muted = ﱝ
        label-muted-foreground = #aa6666

        ramp-volume-0 = 
        ramp-volume-1 = 
        ramp-volume-2 = 

        ${if cfg.batteryCombined then ''
        [module/bat-combined]
        type = custom/script
        exec = ${batteryCombined}/bin/battery-combined-udev
        tail = true
        '' else ''
        [module/bat]
        type = internal/battery
        full-at = 99
        adapter = ADP1
        battery = ${cfg.bat}
        poll-interval = 2
        format-charging = <animation-charging>  <label-charging>
        label-charging = %percentage%%
        format-discharging = <animation-discharging>  <label-discharging>
        label-discharging = %percentage%%
        label-full = "  100%"

        animation-charging-0 = 
        animation-charging-1 = 
        animation-charging-2 = 
        animation-charging-3 = 
        animation-charging-4 = 

        animation-discharging-0 = 
        animation-discharging-1 = 
        animation-discharging-2 = 
        animation-discharging-3 = 
        animation-discharging-4 = 
        ''}
        [module/date]
        type=internal/date
        internal=1
        date=%d %b
        label=%time%  %date%
        time=%H:%M:%S

        [module/tray]
        type = internal/tray
        tray-spacing = 6px
        tray-size = 100%:-6px
      '';
    };
  };

}
