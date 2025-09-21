{ pkgs, inputs, ... }:

{ 
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    image = ../../resources/wallpaper/bon-fire-pixelart.png;
    targets = {
      gnome.enable = true;
      nixos-icons.enable = true;
      gtk.enable = true;
      
    };

   

  };




}
