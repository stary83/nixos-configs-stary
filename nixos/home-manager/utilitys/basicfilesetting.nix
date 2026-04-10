{ config, ... }:

{

  home.file.".face".source = ../../resources/.face;
  home.file.".current_wallpaper".source = config.stylix.image;

}
