{ pkgs, ... }: {
  # Creates a wallust.toml file inside of ~/.config/wallust or overwrites it with the given values of the file included in the repo 
  xdg.configFile."./wallust/wallust.toml".source =
    ../../../resources/theming/wallust/wallust.toml;
  home.packages = with pkgs; [
    wallust
  ];
}
