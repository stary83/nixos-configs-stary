{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    env = "GDK_SCALE,1";
    monitor = "eDP-1,1920x1080,0x0,1.25";
  };
  home.sessionVariables.GDK_SCALE = "1";
}
