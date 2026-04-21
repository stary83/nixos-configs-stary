{ config, inputs, pkgs, ... }:
{
  programs = {
    ghostty = {
      enable = true;
      settings = {
        font-size = 11;
        window-decoration = false;
        confirm-close-surface = false;
        font-feature = ["-liga" "-dlig" "-calt"];
        theme = "Matugen";
        background-blur = 4;
      };
    };
  };
}
