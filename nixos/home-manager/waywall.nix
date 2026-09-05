{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    waywall 
  ];

  home.file.".config/waywall/init.lua".source = ../resources/dots/waywall/init.lau;

}