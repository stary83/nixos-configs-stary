{ pkgs, ... }:

{

  home.packages = with pkgs; [
    pass
    passqt
    rofi-pass
  ];




}
