{ config, lib, pkgs, ... }:
let
  home-config = {

  };
  cfg = config.custom.desktop.polybar;
in
{
  options.custom.desktop.polybar = {
    mpd = lib.mkEnableOption "polybar mpd module";
  }

  home-manager.users.skolem = { ... }: {
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

        background = ${color.bg}
        foreground = ${color.fg}
        dim-value = 1.0

        module-margin-left = 1
        module-margin-right = 2

        modules-left = ewmh
        modules-right = ${if cfg.mpd then "mpd " else ""}temp fs wifi ethernet bat vol date
        tray-position = right

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
        port = 6600'' else ""}

        format-online = <label-song> 
        format-playing = <label-song> <icon-play>
        format-paused = <label-song> <icon-pause>
        format-stopped = <label-song> <icon-stop>
        
        icon-play = 
        icon-pause = 
        icon-stop = 
        
        [module/fs]
        type = internal/fs
        mount-0 = /
        interval = 10
        fixed-values = true
        label-mounted =  %free%
        
        [module/temp]
        type = internal/temperature
        
        [module/wifi]
        type = internal/network
        interface = wlp2s0
        interval = 3
        label-connected = 直 %local_ip%
        
        [module/ethernet]
        type = internal/network
        interface = enp1s0f0
        interval = 3
        label-connected =  %local_ip%
        
        [module/vol]
        type = internal/pulseaudio
        interval = 1
        format-volume = <ramp-volume> <label-volume>
        label-muted = ﱝ
        label-muted-foreground = #aa6666
        
        ramp-volume-0 = 
        ramp-volume-1 = 
        ramp-volume-2 = 
        
        [module/custom-bat]
        type = custom/script
        exec = battery_level BAT0
        interval = 10
        label =   %output%%
        
        [module/bat]
        type = internal/battery
        full-at = 99
        adapter = ADP1
        battery = BAT1
        poll-interval = 2
        format-charging = <animation-charging>  <label-charging>
        label-charging = %percentage%%
        format-discharging = <animation-discharging>  <label-discharging>
        label-discharging = %percentage%%
        
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
        
        [module/date]
        type=internal/date
        internal=1
        date=%d %b
        label=%time%  %date%
        time=%H:%M:%S
      '';
    }
  };

}
