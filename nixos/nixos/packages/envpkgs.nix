{ pkgs, inputs, ... }:

let
  unstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux;

in {

  environment.gnome.excludePackages = with pkgs; [
    orca
    evince
    # file-roller
    geary
    gnome-disk-utility
    # seahorse
    # sushi
    # sysprof
    # gnome-shell-extensions
    adwaita-icon-theme
    # nixos-background-info
    gnome-backgrounds
    # gnome-bluetooth
    # gnome-color-manager
    # gnome-control-center
    # gnome-shell-extensions
    gnome-tour # GNOME Shell detects the .desktop file on first log-in.
    gnome-user-docs
    # glib # for gsettings program
    # gnome-menus
    # gtk3.out # for gtk-launch program
    # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
    # xdg-user-dirs-gtk # Used to create the default bookmarks
    #
    baobab
    epiphany
    gnome-text-editor
    gnome-calculator
    gnome-calendar
    gnome-characters
    # gnome-clocks
    gnome-console
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-weather
    # loupe
    # nautilus
    gnome-connections
    simple-scan
    snapshot
    totem
    yelp
    gnome-software
  ];
  
  environment.systemPackages = with pkgs; [
    brightnessctl # allows to control brightness
    playerctl # allows for video/audio playback control
    wl-clipboard # clipboard manager
    clipse # clipboard manager
    overskride # bluetooth manager app
    blueman
    jq # needed for the waybar script
    pavucontrol # audio control
    waywall # minecraft speedrunning utilitys
    lua
    xwayland-satellite # needed for niri, its how niri manages x11
    protonup-qt
    zeal


    inputs.matugen.packages.${stdenv.hostPlatform.system}.default
    #greetd.greetd
    #greetd.tuigreet
     
    gvfs
    udisks2
    usbutils
    gphoto2
    darktable


    vim
    wget
    tree
    curl
    vlc
    htop
    ffmpeg
    neofetch
    php

    gnome-tweaks 
    nautilus # file manager

    xdg-utils
    google-chrome
    neovim
    yt-dlp
    gnome-keyring
    libsecret
    jdk
    vscode
    alacritty
    libgcc
    unstable.ghostty
    prismlauncher
    gcc
    unrar
    rar
    base16-schemes
    #davinci-resolve
    clinfo
    httrack
    freetube

    localsend 
    telegram-desktop

    deluge # torrent client
    #torrential # not in the 25.11 stable release right now

    python3
    python3Packages.pygobject3

    power-profiles-daemon
    # floorp #browser
    
    bluez
  ];

}
