{ ... }:
{ 
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
      position = "top";
      exclusive = true;
      passthrough = false;
      gtk-layer-shell = true;
      ipc = true;
      fixed-center = true;
      margin-top = 0;
      margin-left = 0;
      margin-right = 0;
      margin-bottom = 0;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = ["clock" "custom/notification"];
# modules-center = ["idle_inhibitor" "clock"];
      modules-right = [ "pulseaudio" "network" "bluetooth" "tray" "battery" ];

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

      "custom/icon" = {
        format = " ";
      };
      "mpris" = {
        format = "{player_icon} {title} - {artist}";
        format-paused = "{status_icon} <i>{title} - {artist}</i>";
        player-icons = {
          default = "▶";
          spotify = "";
          mpv = "󰐹";
          vlc = "󰕼";
          firefox = "";
          chromium = "";
          kdeconnect = "";
          mopidy = "";
        };
        status-icons = {
          paused = "⏸";
          playing = "";
        };
        ignored-players = ["firefox" "chromium"];
        max-length = 30;
      };
      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        active-only = false;
        on-click = "activate";
        persistent-workspaces = {
          "*" = [1 2 3 4 5 6 7 8 9 0];
        };
      };

      "hyprland/window" = {
        format = "  {}";
        separate-outputs = true;
        rewrite = {
          "harvey@hyprland =(.*)" = "$1 ";
          "(.*) — Mozilla Firefox" = "$1 󰈹";
          "(.*)Mozilla Firefox" = " Firefox 󰈹";
          "(.*) - Visual Studio Code" = "$1 󰨞";
          "(.*)Visual Studio Code" = "Code 󰨞";
          "(.*) — Dolphin" = "$1 󰉋";
          "(.*)Spotify" = "Spotify 󰓇";
          "(.*)Spotify Premium" = "Spotify 󰓇";
          "(.*)Steam" = "Steam 󰓓";
        };
        max-length = 1000;
      };

      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "󰥔";
          deactivated = "";
        };
      };

      "clock" = {
        format = "{:%a %d %b %R}";
        format-alt = "{:%I:%M %p}";
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


      "backlight" = {
        interval = 2;
        format = "{icon} {percent}%";
        format-icons = ["" "" "" "" "" "" "" "" ""];
        on-scroll-up = "brightnessctl set 5%+";
        on-scroll-down = "brightnessctl set 5%-";
        smooth-scrolling-threshold = 1;
      };

      "network" = {
        format-wifi = "󰤨 ";
        format-ethernet = "󱘖 Wired";
        tooltip-format = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes} {essid}";
        format-linked = "󱘖 {ifname} (No IP)";
        format-disconnected = " Disconnected";
        format-alt = "󰤨 {signalStrength}%";
        interval = 5;
      };

      "bluetooth" = {
        format = "";
        format-disabled = ""; # an empty format will hide the module
          format-connected = "";
        tooltip-format = " {device_alias}";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = " {device_alias}";
        #on-click = "ghostty -T \"pop-up\" zsh -c \"bluetui\"";
      };

      "pulseaudio" = {
        format = "{icon}  {volume}";
        format-muted = " ";
        on-click = "pavucontrol -t 3";
        tooltip-format = "{icon} {desc} // {volume}%";
        scroll-step = 5;
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
      };

      "pulseaudio#microphone" = {
        format = "{format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        on-click = "pavucontrol -t 4";
        tooltip-format = "{format_source} {source_desc} // {source_volume}%";
        scroll-step = 5;
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
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{time} {icon}";
        format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
      };

      "custom/power" = {
        format = "{}";
        on-click = "wlogout -b 4";
        interval = 86400; # once every day
          tooltip = true;
        };
      }
    ];
    style = ''
    * {
        font-family: 'Noto Sans Mono', 'Font Awesome 6 Free', 'Font Awesome 6 Brands', monospace;
        font-size: 13px;
    }

    window#waybar {
        background-color: black;
        color: #ffffff;
        transition-property: background-color;
        transition-duration: .5s;
    }

    window#waybar.hidden {
        opacity: 0.2;
    }

    window#waybar.termite {
        background-color: #3F3F3F;
    }

    window#waybar.chromium {
        background-color: #000000;
        border: none;
    }

    button {
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 0;
    }

    button:hover {
        background: inherit;
        box-shadow: inset 0 -3px #ffffff;
    }

    #pulseaudio:hover {}

    #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #ffffff;
    }

    #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
    }

    #workspaces button.focused {
        background-color: #64727D;
        box-shadow: inset 0 -3px #ffffff;
    }

    #workspaces button.urgent {
        background-color: #eb4d4b;
    }

    #mode {
        background-color: #64727D;
        box-shadow: inset 0 -3px #ffffff;
    }

    #custom-waypaper,
    #clock,
    #battery,
    #cpu,
    #memory,
    #disk,
    #temperature,
    #backlight,
    #network,
    #pulseaudio,
    #wireplumber,
    #custom-media,
    #tray,
    #mode,
    #idle_inhibitor,
    #scratchpad,
    #power-profiles-daemon,
    #mpd {
        padding: 0 10px;
        color: #ffffff;
    }

    #workspaces {
        margin: 0 4px;
    }

    .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
    }

    .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
    }

    #clock {
        font-size: 17px;
        margin-right: 10px;
    }

    #battery {
        background-color: #ffffff;
        color: #000000;
    }

    #battery.charging, #battery.plugged {
        color: #ffffff;
        background-color: #26A65B;
    }

    @keyframes blink {
        to {
            background-color: #ffffff;
            color: #000000;
        }
    }

    #battery.critical:not(.charging) {
        background-color: #f53c3c;
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: steps(12);
        animation-iteration-count: infinite;
        animation-direction: alternate;
    }

    #power-profiles-daemon {
        padding-right: 15px;
    }

    #power-profiles-daemon.performance {
        background-color: #f53c3c;
        color: #ffffff;
    }

    #power-profiles-daemon.balanced {
        background-color: #2980b9;
        color: #ffffff;
    }

    #power-profiles-daemon.power-saver {
        background-color: #2ecc71;
        color: #000000;
    }

    label:focus {
        background-color: #000000;
    }

    #cpu, #memory, #temperature {
        font-size: 16px;
        margin-right: 10px;
    }

    #disk {
        background-color: #964B00;
    }

    #backlight {
        background-color: #90b1b1;
    }

    #network {
        background-color: #2980b9;
    }

    #network.disconnected {
        background-color: #f53c3c;
    }

    #pulseaudio, #pulseaudio.muted {
        font-size: 17px;
        margin-right: 30px;
    }

    #wireplumber {
        background-color: #fff0f5;
        color: #000000;
    }

    #wireplumber.muted {
        background-color: #f53c3c;
    }

    #custom-media {
        background-color: #66cc99;
        color: #2a5c45;
        min-width: 100px;
    }

    #custom-media.custom-spotify {
        background-color: #66cc99;
    }

    #custom-media.custom-vlc {
        background-color: #ffa000;
    }

    #temperature.critical {
        background-color: #eb4d4b;
    }

    #tray {
        background-color: #2980b9;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #eb4d4b;
    }

    #idle_inhibitor {
        background-color: #2d3436;
    }

    #idle_inhibitor.activated {
        background-color: #ecf0f1;
        color: #2d3436;
    }

    #mpd {
        background-color: #66cc99;
        color: #2a5c45;
    }

    #mpd.disconnected {
        background-color: #f53c3c;
    }

    #mpd.stopped {
        background-color: #90b1b1;
    }

    #mpd.paused {
        background-color: #51a37a;
    }

    #language {
        background: #00b093;
        color: #740864;
        padding: 0 5px;
        margin: 0 5px;
        min-width: 16px;
    }

    #keyboard-state {
        background: #97e1ad;
        color: #000000;
        padding: 0 0px;
        margin: 0 5px;
        min-width: 16px;
    }

    #keyboard-state > label {
        padding: 0 5px;
    }

    #keyboard-state > label.locked {
        background: rgba(0, 0, 0, 0.2);
    }

    #scratchpad {
        background: rgba(0, 0, 0, 0.2);
    }

    #scratchpad.empty {
        background-color: transparent;
    }

    #privacy {
        padding: 0;
    }

    #privacy-item {
        padding: 0 5px;
        color: white;
    }

    #privacy-item.screenshare {
        background-color: #cf5700;
    }

    #privacy-item.audio-in {
        background-color: #1ca000;
    }

    #privacy-item.audio-out {
        background-color: #0069d4;
    }

    #custom-fedora {
        font-size: 18px;
        background-image: url('/home/alerion/.config/waybar/assets/fedora.svg');
        background-position: center;
        background-repeat: no-repeat;
        background-size: contain;
        margin-top: 3px;
        margin-left: 20px;
        margin-bottom: 10px;
    }

    #custom-nix {
        font-size: 23px;
        background-image: url('/home/alerion/.config/waybar/assets/nix.png');
        background-position: center;
        background-repeat: no-repeat;
        background-size: contain;
        margin-top: 3px;
        margin-right: 3px;
        margin-bottom: 10px;
        margin-left: -5px;
    }

    #custom-waypaper {
        font-size: 16px;
        margin-left: 20px;
    }

    #window {
        font-size: 5px;
        margin-left: 40px;
    }

    #mpris {
        font-size: 16px;
        padding-left: 20px;
        padding-right: 20px;
    }

    #bluetooth {
        font-size: 18px;
        margin-right: 30px;
    }

    #systemd-failed-units {
        font-size: 17px;
        margin-left: 10px;
    }

    #custom-power {
        font-size: 18px;
        margin-right: 20px;
    }
    
    '';
  };

}
