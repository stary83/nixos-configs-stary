{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    waywall 
  ];

  home.file.".config/waywall".source = ../resources/dots/waywall;

}