{ ... }: 
{
  
  services = {
    # Enable the Gnome Dekstop Environment & x11 windowing system
    desktopManager = {
      gnome.enable = true;
    };
    displayManager = {
      gdm.enable = true;
      sddm.wayland.enable = true;
      defaultSession = "niri";
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us"; #add ir for farsi
        variant = "";
        #options = "grp:alt_space_toggle";
      };
      #libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    timesyncd.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    gvfs.enable = true;
    udisks2.enable = true;
  };

}
