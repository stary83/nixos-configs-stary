{ config, pkgs, lib, ... }:
let 
powerMenuMadeByMePackage = pkgs.writeScriptBin "powerMenuMadeByMe" ''
    #!${pkgs.bash}/bin/bash
    
    rofi_command() {
      ${pkgs.rofi}/bin/rofi -dmenu -i -config "$HOME/.config/rofi/power.rasi"
    }

    shutdown=" 󰐥 | Shutdown"
    reboot="  | Restart" 
    lock="  | Lock" 
    suspend=" 󰤄 | Suspend"
    logout=" 󰍂 | Logout"

    chosen=$(echo -e "$shutdown\n$reboot\n$logout\n$suspend\n$lock" | rofi_command)

    case "$chosen" in
    "$shutdown")
    systemctl poweroff
    ;;
    "$reboot")
    systemctl reboot
    ;;
    "$lock")
    if command -v hyprlock &>/dev/null; then
      hyprlock
    elif command -v swaylock &>/dev/null; then
      swaylock -f
    elif command -v gtklock &>/dev/null; then
      gtklock
    else
      notify-send -t 1500 "Error: No lock utility found."
    fi
    ;;
    "$suspend")
    mpc -q pause
    amixer set Master mute
    systemctl suspend
    ;;
    "$logout")
    handle_logout
    ;;
    esac

handle_logout() {
  case "$DESKTOP_SESSION" in
  hyprland)
    hyprctl dispatch exit
    ;;
  sway)
    swaymsg exit
    ;;
  i3)
    i3-msg exit
    ;;
  river)
    riverctl exit
    ;;
  niri)
    niri msg action quit
    ;;
  Openbox)
    openbox --exit
    ;;
  bspwm)
    bspc quit
    ;;
  xfce)
    killall xfce4-session
    ;;
  *)
    notify-send -t 1500 "Logout for '$DESKTOP_SESSION' not implemented."
    exit 1
    ;;
  esac
  }
  '';


in { 
  home.packages = with pkgs; [ powerMenuMadeByMePackage ];
}
