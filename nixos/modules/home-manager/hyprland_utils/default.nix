{ config, pkgs, lib, ... }: {
  imports = [
    ./hyprlock.nix
    ./swaylock.nix

    ./hypridle.nix
    ./waybar.nix
    ./swww.nix
    
    #./hyprpanel.nix
    #./hyprpaper.nix
  ];
}
