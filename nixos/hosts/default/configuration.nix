# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  unstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux;
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];
  
  main-user.enable = true;
  main-user.userName = "stary";

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "StarThought"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  # Makes timedatectl ntp bet true
  networking.timeServers = [ "pool.ntp.org" "time.google.com" "time.windows.com" ];
  services.timesyncd.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  services.xserver.videoDrivers = [ "modesetting" ];
  
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the Gnome Dekstop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;


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
 


  hardware.graphics.enable = true;

  # For Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us"; #add ir for farsi
    variant = "";
    #options = "grp:alt_space_toggle";
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "stary" = {
        imports = [
          ./home.nix
	  inputs.self.outputs.homeManagerModules.default
        ];
      };
    };
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;	
  
  # Allow appimage files to be run
  programs.appimage.binfmt = true;
 
  nixpkgs.config.allowBroken = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  
  environment.systemPackages = with pkgs; [
    gnome-tweaks #for gnome speciffically
    gnome-console #for gnome speciffically
    nautilus # file manager
    google-chrome
    neovim
    yt-dlp
    gnome-keyring
    libsecret
    jdk
    linux-wifi-hotspot
    vscode
    # -------------wine pkgs for gaming
    wineWowPackages.full
    giflib
    gnutls
    v4l-utils
    libpulseaudio
    alsa-plugins
    alsa-lib
    sqlite
    xorg.libXcomposite
    ocl-icd
    libva
    gtk3
    gst_all_1.gst-plugins-base
    vulkan-loader
    SDL2
    winetricks
    wineWowPackages.staging
    dxvk
    # ---------------- end of wine pkgs
    alacritty
    libgcc
    appimage-run
    unstable.ghostty
    prismlauncher
    gcc
    torrential
    openvpn
    smartdns
    sstp
    unrar
    wireguard-tools
    libproxy
    davinci-resolve
    pass
  ];


  fonts = {
    fontDir.enable = true;  # Ensures /run/current-system/sw/share/X11/fonts exists
    packages = with pkgs; [
      corefonts
      #xb-roya # Custom XB Roya font
      #xb-titre # Custom XB Titre font
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
