{ config, pkgs, lib, ... }: {
  imports = [
    ./hyprlock.nix
    ./hypridle.nix
    ./waybar.nix
    ./swww.nix
    ./basicfilesetting.nix
  ];
}
