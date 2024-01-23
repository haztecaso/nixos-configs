# TODO: Este módulo instala muchos paquetes. Estaría bien que solo se activaran
# los comandos de las aplicaciones que están instaladas.
{ config, lib, pkgs, ... }:
let
  term_launcher = pkgs.writeScriptBin "term_launcher" ''
    #!${pkgs.runtimeShell}
    p=$(ps -ef)
    n=$(echo -e "$p" | grep -c "alacritty -e ${pkgs.tmux}/bin/tmux new-session -A -s 0")
    if [ "$n" -gt 0 ]; then
        ${pkgs.alacritty}/bin/alacritty
    else
        ${pkgs.alacritty}/bin/alacritty -e ${pkgs.tmux}/bin/tmux new-session -A -s 0
    fi
  '';

  dunstify_cmd1 = "${pkgs.dunst}/bin/dunstify -r 1001 -t 800";
  dunstify_cmd2 = "${pkgs.dunst}/bin/dunstify -r 1002";

  notify_vol = pkgs.writeScriptBin "notify_vol" ''
    #!${pkgs.runtimeShell}
    VOL=$(${pkgs.pamixer}/bin/pamixer --get-volume-human)
    if echo $VOL | grep -q muted; then
      ${dunstify_cmd1} -h string:bgcolor:#550000 -h string:frcolor:#550000 Volume Muted
    else
      ${dunstify_cmd1} -h int:value:$VOL Volume
    fi
  '';

  notify_bri = pkgs.writeScriptBin "notify_bri" ''
    #!${pkgs.runtimeShell}
    ${dunstify_cmd1} -h string:hlcolor:#cccc22 -h int:value:$(${pkgs.light}/bin/light -G) "Screen brightness"
  '';

  kbddev = "sysfs/leds/smc::kbd_backlight ";
  notify_kbd = pkgs.writeScriptBin "notify_kbd" ''
    #!${pkgs.runtimeShell}
    ${dunstify_cmd1} -h string:hlcolor:#aaaabb -h int:value:$(${pkgs.light}/bin/light -s ${kbddev} -G) "Keyboard brightness"
  '';

  pamixer_cmd = cmd: "${pkgs.pamixer}/bin/pamixer ${cmd} && ${notify_vol}/bin/notify_vol";
  light_cmd = cmd: "${pkgs.light}/bin/light ${cmd} && ${notify_bri}/bin/notify_bri";
  light_kbd_cmd = cmd: "${pkgs.light}/bin/light -s ${kbddev} ${cmd} && ${notify_kbd}/bin/notify_kbd";

  mpd_random = pkgs.writeScriptBin "mpd_random" ''
    #!${pkgs.runtimeShell}
    status=$(${pkgs.mpc_cli}/bin/mpc random | sed -n 's/^.*random: \([a-z]\+\).*$/\1/p')
    if [ "$status" == "on" ]; then
      ${dunstify_cmd1} -h string:bgcolor:#003300 Random ON
    else
      ${dunstify_cmd1} -h string:bgcolor:#330000 Random OFF
    fi
  '';

  run_if_present = pkgs.writeScriptBin "run_if_present" ''
    if ! command -v $1 &> /dev/null; then
      ${dunstify_cmd2} "binary \"$1\" not in path" "(run_if_present script)"
    else
      $1
    fi
  '';
  mkRunIfPresent = cmd: "${run_if_present}/bin/run_if_present ${cmd}";
in
{
  config = lib.mkIf config.custom.desktop.enable {
    services.sxhkd = {
      enable = true;
      keybindings = {
        # "super + shift + alt + r" = "${pkgs.gksu}/bin/gksu \"${pkgs.systemd}/bin/systemctl restart user.slice\""; #TODO: find replacement for gksu
        # Launchers
        "super + Return" = mkRunIfPresent "alacritty";
        "super + alt + Return" = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.tmux}/bin/tmux new-session -A -s 0";
        "super + shift + Return" = "${term_launcher}/bin/term_launcher";
        "super + e" = mkRunIfPresent "emacs";
        "super + {space,s,c}" = "rofi -show {run,ssh,calc}";
        "super + w" = mkRunIfPresent "qutebrowser";
        # "super + shift + w" = mkRunIfPresent "qutebrowser --target private-window";
        "super + alt + w" = mkRunIfPresent "firefox";
        "super + shift + b" = mkRunIfPresent "bitwarden";
        "super + shift + t" = mkRunIfPresent "telegram-desktop";
        "super + {XF86LaunchA, Print}" = "${pkgs.flameshot}/bin/flameshot gui";
        "XF86LaunchB" = "${pkgs.alacritty}/bin/alacritty -e ssh skolem@haztecaso.com";
        "{XF86Eject, XF86Favorites}" = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";

        # Media keys
        "XF86Audio{Prev,Next,Play}" = "${pkgs.playerctl}/bin/playerctl -p mpd {previous,next,play-pause}";
        "super + alt + XF86Audio{Prev,Next,Play}" = "${pkgs.playerctl}/bin/playerctl {previous,next,play-pause}";
        "super + XF86Audio{Prev,Next}" = "${pkgs.playerctl}/bin/playerctl -p mpd position 2{-,+}";
        "super + XF86AudioPlay" = "${mpd_random}/bin/mpd_random";

        # Volume
        "XF86Audio{Raise,Lower}Volume" = pamixer_cmd "{-i,-d} 10";
        "super + XF86Audio{Raise,Lower}Volume" = pamixer_cmd "{-i,-d} 5";
        "super + alt + XF86Audio{Raise,Lower}Volume" = pamixer_cmd "{-i,-d} 1";
        "XF86AudioMute" = pamixer_cmd "-t";
        "XF86AudioMicMute" = pamixer_cmd "--source 1 -t";
        "super + XF86AudioMute" = pamixer_cmd "--set-volume 0";

        # Screen brightness
        "XF86MonBrightness{Up,Down}" = light_cmd "{-A,-U} 5";
        "super + alt + XF86MonBrightness{Up,Down}" = light_cmd "{-A,-U} 1";
        "super + XF86MonBrightness{Up,Down}" = light_cmd "-S {100,0}";

        # Keyboard brightness
        "XF86KbdBrightness{Up,Down}" = light_kbd_cmd "{-A,-U} 5";
        "super + alt + XF86KbdBrightness{Up,Down}" = light_kbd_cmd "{-A,-U} 1";
        "super + XF86KbdBrightness{Up,Down}" = light_kbd_cmd "-S {100,0}";
      };
    };
  };
}
