{ ... }: {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
        "suppressevent maximize, class:.*"
          "opacity 1.0 1.0,class:^(firefox)$"
          "opacity 0.90 0.90,class:^(Google-chrome)$"
          "opacity 0.90 0.90,class:^(Brave-browser)$"
          "opacity 1.0 1.0,class:^(code-oss)$"
          "opacity 1.0 1.0,class:^([Cc]ode)$"
          "opacity 0.80 0.80,class:^(nautilus)$"
          "opacity 0.80 0.80,class:^(org.kde.ark)$"
          "opacity 0.80 0.80,class:^(nwg-look)$"
          "opacity 0.80 0.80,class:^(qt5ct)$"
          "opacity 0.80 0.80,class:^(qt6ct)$"
          "opacity 0.80 0.80,class:^(kvantummanager)$"
          "opacity 0.80 0.70,class:^(org.pulseaudio.pavucontrol)$"
          "opacity 0.80 0.70,class:^(blueman-manager)$"
          "opacity 0.80 0.70,class:^(nm-applet)$"
          "opacity 0.80 0.70,class:^(nm-connection-editor)$"
          "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"
          "opacity 0.80 0.70,class:^(polkit-gnome-authentication-agent-1)$"
          "opacity 0.80 0.70,class:^(org.freedesktop.impl.portal.desktop.gtk)$"
          "opacity 0.80 0.70,class:^(org.freedesktop.impl.portal.desktop.hyprland)$"
          "opacity 0.70 0.70,class:^([Ss]team)$"
          "opacity 0.70 0.70,class:^(steamwebhelper)$"
          "opacity 0.70 0.70,class:^([Ss]potify)$"
          "opacity 0.70 0.70,initialTitle:^(Spotify Free)$"
          "opacity 0.70 0.70,initialTitle:^(Spotify Premium)$"

          "opacity 0.90 0.90,class:^(com.github.rafostar.Clapper)$" # Clapper-Gtk
          "opacity 0.80 0.80,class:^(com.github.tchx84.Flatseal)$" # Flatseal-Gtk
          "opacity 0.80 0.80,class:^(hu.kramo.Cartridges)$" # Cartridges-Gtk
          "opacity 0.80 0.80,class:^(com.obsproject.Studio)$" # Obs-Qt
          "opacity 0.80 0.80,class:^(gnome-boxes)$" # Boxes-Gtk
          "opacity 0.80 0.80,class:^(vesktop)$" # Vesktop
          "opacity 0.80 0.80,class:^(discord)$" # Discord-Electron
          "opacity 0.80 0.80,class:^(WebCord)$" # WebCord-Electron
          "opacity 0.80 0.80,class:^(ArmCord)$" # ArmCord-Electron
          "opacity 0.80 0.80,class:^(app.drey.Warp)$" # Warp-Gtk
          "opacity 0.80 0.80,class:^(net.davidotek.pupgui2)$" # ProtonUp-Qt
          "opacity 0.80 0.80,class:^(yad)$" # Protontricks-Gtk
          "opacity 0.80 0.80,class:^(Signal)$" # Signal-Gtk
          "opacity 0.80 0.80,class:^(io.github.alainm23.planify)$" # planify-Gtk
          "opacity 0.80 0.80,class:^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk
          "opacity 0.80 0.80,class:^(com.github.unrud.VideoDownloader)$" # VideoDownloader-Gtk
          "opacity 0.80 0.80,class:^(io.gitlab.adhami3310.Impression)$" # Impression-Gtk
          "opacity 0.80 0.80,class:^(io.missioncenter.MissionCenter)$" # MissionCenter-Gtk
          "opacity 0.80 0.80,class:^(io.github.flattool.Warehouse)$" # Warehouse-Gtk

          "float,class:^(org.kde.dolphin)$,title:^(Progress Dialog — Dolphin)$"
          "float,class:^(org.kde.dolphin)$,title:^(Copying — Dolphin)$"
          "float,title:^(About Mozilla Firefox)$"
          "float,class:^(firefox)$,title:^(Picture-in-Picture)$"
          "float,class:^(firefox)$,title:^(Library)$"
          "float,class:^(kitty)$,title:^(top)$"
          "float,class:^(kitty)$,title:^(btop)$"
          "float,class:^(kitty)$,title:^(htop)$"
          "float,class:^(vlc)$"
          "float,class:^(kvantummanager)$"
          "float,class:^(qt5ct)$"
          "float,class:^(qt6ct)$"
          "float,class:^(nwg-look)$"
          "float,class:^(org.kde.ark)$"
          "float,class:^(org.pulseaudio.pavucontrol)$"
          "float,class:^(blueman-manager)$"
          "float,class:^(nm-applet)$"
          "float,class:^(nm-connection-editor)$"
          "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"

          "float,class:^(Signal)$" # Signal-Gtk
          "float,class:^(com.github.rafostar.Clapper)$" # Clapper-Gtk
          "float,class:^(app.drey.Warp)$" # Warp-Gtk
          "float,class:^(net.davidotek.pupgui2)$" # ProtonUp-Qt
          "float,class:^(yad)$" # Protontricks-Gtk
          "float,class:^(eog)$" # Imageviewer-Gtk
          "float,class:^(io.github.alainm23.planify)$" # planify-Gtk
          "float,class:^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk
          "float,class:^(com.github.unrud.VideoDownloader)$" # VideoDownloader-Gkk
          "float,class:^(io.gitlab.adhami3310.Impression)$" # Impression-Gtk
          "float,class:^(io.missioncenter.MissionCenter)$" # MissionCenter-Gtk

# common modals
          "float,title:^(Open)$"
          "float,title:^(Choose Files)$"
          "float,title:^(Save As)$"
          "float,title:^(Confirm to replace files)$"
          "float,title:^(File Operation Progress)$"
          "float,class:^(xdg-desktop-portal-gtk)$"

          "float, title:^(pop-up)$"
          "pin, title:^(pop-up)$"
          "size 800 600, title:^(pop-up)$"
         ];

 

    layerrule = [
      "blur,rofi"
      "blur, waybar"
      "blur, foot"
    ];
  };
}
