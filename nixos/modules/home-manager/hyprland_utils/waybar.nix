{ config, pkgs, lib, ... }:
let 
powerMenuMadeByMePackage = pkgs.writeScriptBin "powerMenuMadeByMePackage" ''
    #!${pkgs.bash}/bin/bash
    
    # Options
    shutdown="Shutdown"
    reboot="Reboot"
    lock="Lock"

    # Show menu
    options="$shutdown\n$reboot\n$lock"
    selected=$(echo -e "$options" | ${pkgs.wofi}/bin/wofi  -dmenu -p "Power Menu")

    case $selected in
        $shutdown)
            poweroff
            ;;
        $reboot)
            reboot
            ;;
        $lock)
            hyprlock
            ;;
    esac
  '';
applicationMenuMadeByMe = pkgs.writeScriptBin "applicationMenuMadeByMe" ''
    #!${pkgs.bash}/bin/bash
    # Dependencies
    ${pkgs.wofi}/bin/wofi -show drun
  '';



in { 
  home.packages = with pkgs; [ powerMenuMadeByMePackage applicationMenuMadeByMe ];
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    settings = [
    {
      layer = "top";
      height = 20;
      spacing = 0;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = ["clock" "custom/notification"];
      modules-right = [ "pulseaudio" "network" "bluetooth" "tray" "battery" ];
      
      "custom/apps" = {
        format = "-";
	iconsize = 24;
	tooltip = true;
	tooltip-format = "App launcher";
        onclick = "${lib.getExe pkgs.wofi}/bin/wofi -show drun";
      };
      "custom/power" = {
        format = "⏻";
        tooltip = false;
	onclick = "${pkgs.bash}/bin/bash powerMenuMadeByMePackage";
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        disable-scroll = true;
        all-outputs = true;
        active-only = false;
        on-click = "activate";
        persistent-workspaces = {
          "*" = [1 2 3 4 5 6 7 8 9 10];
        };
      };

      "clock" = {
        format = "{:%H:%M - %b %d}";
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b>{}</b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-click-forward = "tz_up";
          on-click-backward = "tz_down";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      "network" = {
        format-wifi = "<span size='12500' >󰤥</span>";
        format-ethernet = "<span size='12500' >󰤥</span>";
	format-disabled = "<span size='12500'>󰤮</span>";
        tooltip-format = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes} {essid}";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "<span size='12500'>󰤮</span>";
        interval = 5;
      };

      "bluetooth" = {
        format = "<span size='13000' >󰂯</span>";
        tooltip-format = " {device_alias}";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = " {device_alias}";
        on-click = "overskride";
      };

      "pulseaudio" = {
        format = "<span size='13000'>{icon}</span>";
        format-muted = "<span size='13000'>󰖁</span>";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "󰖀" "󰕾" "" ];
        };
        on-click = "pavucontrol";
      };

      "tray" = {
        icon-size = 12;
        spacing = 5;
      };

      "battery" = {
        states = {
          good = 95;
          warning = 30;
          critical = 20;
        };
        format = "<span size='13000' foreground='#B1E3AD'>{icon}</span> {capacity}%";
	format-warning = "<span size='13000' foreground='#B1E3AD'>{icon}</span> {capacity}%";
	format-critical = "<span size='13000' foreground='#E38C8F'>{icon}</span> {capacity}%";
        format-charging = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
        format-plugged = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
        format-alt = "<span size='13000' foreground='#B1E3AD'>{icon}</span> {time}";
	format-full = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
        format-icons = ["" "" "" "" ""];
	tooltip-format = "{time}";
      };
    }
    ];
  };

  home.file.".config/waybar/style.css" = {
    force = true; 
    source = ../../../resources/dots/waybar/style.css;
  };
}
