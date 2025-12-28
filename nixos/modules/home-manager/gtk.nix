{ pkgs, ... }: {
  gtk = {
    enable = true;
  };
  home.file.".config/gtk-2.0" = {
    source = ../../resources/dots/gtk2;
    recursive = true;
    force = true;
  };
  home.file.".config/gtk-3.0" = {
    source = ../../resources/dots/gtk3;
    recursive = true;
    force = true;
  };
  home.file.".config/gtk-4.0" = {
    source = ../../resources/dots/gtk4;
    recursive = true;
    force = true;
  };
  home.file.".themes/Gruvbox-BL-MB-Dark" = {
    source = ../../resources/dots/Gruvbox-BL-MB-Dark;
    recursive = true;
    force = true;
  };
}
