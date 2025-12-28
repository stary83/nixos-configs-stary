{ pkgs, ... }:{
  home.packages = with pkgs; [ rofi ];
  home.file.".config/rofi/config.rasi" = {
    source = ../../resources/dots/rofi/config.rasi;
    force = true;
  };

}
