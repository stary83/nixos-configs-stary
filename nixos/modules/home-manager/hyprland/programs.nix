{ ... }: {

  wayland.windowManager.hyprland.settings = {
    # source file is generated with wallust
    source = "~/.config/hypr/colors-hyprland.conf";
    "$term" = "ghostty"; 
    # "$term" = "foot";
    # "$term" = "alacritty";
    "$fileManager" = "nautilus";
    "$editor" = "nvim";
    };
}
