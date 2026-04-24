{ pkgs, ... }:
{
  
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];
  powerManagement.powertop.enable = true;
  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
   
  fonts = {
    fontDir.enable = true;  # Ensures /run/current-system/sw/share/X11/fonts exists
    packages = with pkgs; [
      corefonts
      nerd-fonts.jetbrains-mono
      roboto
      source-sans
      font-awesome
      openmoji-color
      #xb-roya # Custom XB Roya font
      #xb-titre # Custom XB Titre font
    ];
  };

  environment = {
    variables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      
      terminal = "ghostty";
      term = "ghostty";
    };
    sessionVariables = {
      # for running qt based applications
    };
  };


}
