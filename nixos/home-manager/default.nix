{ pkgs, lib, config, ... }:

{
  imports = [
    ./gpg.nix
    ./git.nix
    ./gtk.nix
    ./qt.nix
    ./hyprland/default.nix
    ./utilitys/default.nix
    ./gnome.nix
    ./ghostty.nix
    ./rofi.nix
    ./wofi.nix
    ./dunst.nix
    ./fastfetch.nix
    ./matugen.nix
    ./obs-studio.nix
    ./gaming.nix
    ./powerMenuMadeByMe.nix
    ./applauncherMenuMadeByMe.nix
    ./niri.nix
  ];
  gpg.enable = true;
  git.enable = true;

}
