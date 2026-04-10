{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ dunst ];
  # ../../resources/dots/dunst, the colors are generated with matugen, if matugen is revomed add manual config setter here
}
