{ config, pkgs, lib, ... }:
let
  appLauncherMenuMadeByMePackage = pkgs.writeScriptBin "alMenuMadeByMe" ''
    #!${pkgs.bash}/bin/bash

    ## Run
    ${pkgs.rofi}/bin/rofi \
      -show drun \
      -theme $HOME/.config/rofi/launcher.rasi

  '';

in {
  home.packages = with pkgs; [ appLauncherMenuMadeByMePackage ];
}
