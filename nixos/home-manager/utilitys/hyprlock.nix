{ pkgs, config, ... }:
{
  programs.hyprlock = {
    enable = true;
  };
  home.file.".config/hypr/hyprlock.conf".source = ../../resources/dots/hyprlock/minimal1-dark/hyprlock.conf; # make sure to set the monitor

}
