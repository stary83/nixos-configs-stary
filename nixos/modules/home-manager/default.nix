{ pkgs, lib, config, ... }:

{
  imports = [
    ./gpg.nix
    ./git.nix
    ./nekoray.nix
    ./hyprland/default.nix
    ./hyprland_utils/default.nix
    ./hyprland_utils/stylix.nix
    ./hyprland_utils/wallust.nix
    ./gnome.nix
    ./ghostty.nix
    ./rofi.nix
    ./qt.nix
    ./gtk.nix
  ];
  gpg.enable = true;
  git.enable = true;
  nekoray.enable = true;

}
