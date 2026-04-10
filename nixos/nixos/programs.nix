{ pkgs, inputs, ... }:
{
  programs = {
    # Allow appimage files to be run
    appimage= {
      enable = true;
      binfmt = true;
    };
    firefox.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".hyprland;
      withUWSM = true;
    };
    # configurations in home-manager
    niri = {
      enable = true;
    };
    
    # Gaming
    gamemode.enable = true;
    steam = {
      enable = true; # Master switch, already covered in installation
      remotePlay.openFirewall = true;  # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
      # this package override is need for steam to work on niri
      package = pkgs.steam.override {
        extraArgs = "-system-composer";
      };
    };


    xwayland.enable = true;

    localsend = {
      enable = true;
      openFirewall = true;
    };
  };

}
