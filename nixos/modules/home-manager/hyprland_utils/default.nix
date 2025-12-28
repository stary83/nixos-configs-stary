{ config, pkgs, lib, ... }: {
  imports = [
    ./hyprlock.nix

    ./hypridle.nix
    ./waybar.nix
    ./swww.nix
    
    #./hyprpanel.nix
    #./hyprpaper.nix
  ];
}
