{ config, ... }: {
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "swww-daemon"
      "waybar &"
      "dunst"
      "matugen image ${config.stylix.image}"
      #"matugen color hex 405B5B"
    ];
  };
}
