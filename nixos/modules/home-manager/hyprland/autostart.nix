{ config, ... }: {
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "swww-daemon && swww img ${config.stylix.image}"
      "wallust run ${config.stylix.image}"
      "waybar"
    ];
  };
}
