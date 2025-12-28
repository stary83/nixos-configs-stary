{ ... }: {

  wayland.windowManager.hyprland.settings = {
    # source file is generated with matugen
    source = "colors.conf";
    "$term" = "ghostty"; 
    # "$term" = "foot";
    # "$term" = "alacritty";
    "$fileManager" = "nautilus";
    "$editor" = "nvim";
    };
}
