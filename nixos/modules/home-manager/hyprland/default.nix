{...}:
{
  wayland.windowManager.hyprland.enable = true;
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
