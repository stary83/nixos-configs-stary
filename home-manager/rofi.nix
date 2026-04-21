{ pkgs, ... }:{
  home.packages = with pkgs; [ rofi ];

  #powermenu
  home.file.".config/rofi/powermenu.rasi" = {
    source = ../resources/dots/rofi/power.rasi;
    force = true;
  };



  # launcher
  home.file.".config/rofi/launcher.rasi" = {
    source = ../resources/dots/rofi/launchers/type-4/style-3.rasi;
    force = true;
  };
  home.file.".config/rofi/shared/font.rasi" = {
    source = ../resources/dots/rofi/launchers/type-4/shared/fonts.rasi;
    force = true;
  };

  

  # colors for the configs imported from https://github.com/adi1090x/rofi
  home.file.".config/rofi/shared/colors.rasi" = {
    source = ../resources/dots/rofi/colors/gruvbox.rasi;
    force = true;
  };

}
