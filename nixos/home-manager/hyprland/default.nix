{...}:
{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.configType = "hyprlang";
  imports = [
    ./bind.nix
    ./input.nix
    ./programs.nix
    ./autostart.nix
    ./theme-loader.nix
    ./animations.nix
    ./monitor.nix
  ];
}
