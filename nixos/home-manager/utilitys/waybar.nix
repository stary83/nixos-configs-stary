{ config, pkgs, lib, ... }:

{ 
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
  };
  home.file.".config/waybar/config.jsonc" = {
    source = ../../resources/dots/waybar/minimal1-dark/config.jsonc;
  };
  home.file.".config/waybar/style.css" = {
    source = ../../resources/dots/waybar/minimal1-dark/style.css;
  };

}
