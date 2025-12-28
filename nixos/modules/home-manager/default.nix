{ pkgs, lib, config, ... }:

{
  imports = [
    ./gpg.nix
    ./git.nix
    ./gtk.nix
    ./qt.nix
    ./nekoray.nix
    ./hyprland/default.nix
    ./hyprland_utils/default.nix
    ./hyprland_utils/stylix.nix
    ./gnome.nix
    ./ghostty.nix
    ./rofi.nix
    ./wofi.nix
    ./dunst.nix
    ./fastfetch.nix
    ./matugen.nix
    ./obs-studio.nix
    ./gaming.nix
  ];
  gpg.enable = true;
  git.enable = true;
  nekoray.enable = true;

}
