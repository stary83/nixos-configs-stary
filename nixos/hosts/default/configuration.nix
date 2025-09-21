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
  
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  powerManagement.powertop.enable = true;

  main-user.enable = true;
  main-user.userName = "stary";
  security = {
    rtkit.enable = true;
    wrappers = {
      nekoray = {
        source = "${pkgs.nekoray}/bin/nekoray";
        capabilities = "cap_net_admin,cap_net_raw,cap_net_bind_service,cap_sys_ptrace,cap_dac_read_search+ep";
        owner = "stary";
        group = "users";
      };
    };
  };


  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  
  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    hostName = "StarThought"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    
    networkmanager.enable = true;

    timeServers = [ "pool.ntp.org" "time.google.com" "time.windows.com" ];

  };

  hardware = {
    graphics.enable = true;
    # For Bluetooth
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  
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


  
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";

    # platformTheme = "qtct";
    # style.name = "kvantum";
  }; 

  programs = {
    # Allow appimage files to be run
    appimage.binfmt = true;
    firefox.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      withUWSM = true;
    };
    gamemode.enable = true;
    xwayland.enable = true;
  };

  services = {
    # Enable the Gnome Dekstop Environment & x11 windowing system
    xserver = {
      enable = true;
      # excludePackages = with pkgs; [ 
      #   xterm 
      # ];
      displayManager.gdm.enable = true;
      desktopManager.kodi.enable = true;
      desktopManager.gnome.enable = true;
      # videoDrivers = [ "modesetting" ];
      xkb = {
        layout = "us"; #add ir for farsi
        variant = "";
        #options = "grp:alt_space_toggle";
      };
    };
    displayManager.defaultSession = "hyprland-uwsm"; # default option after logging in
    

    displayManager.sddm.wayland.enable = true;
    # Enable CUPS to print documents.
    printing.enable = true;

    timesyncd.enable = true;

    pipewire = {
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
  };

  environment = {
    variables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      
      terminal = "ghostty";
    };
    sessionVariables = {
      # for running qt based applications
    };
  };



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


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;	
  
  nixpkgs.config.allowBroken = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  
  environment.systemPackages = with pkgs; [
    brightnessctl # allows to control brightness
    playerctl # allows for video/audio playback control
    wl-clipboard # clipboard manager
    clipse # clipboard manager

    gnome-tweaks 
    nautilus # file manager
    networkmanagerapplet
    xdg-utils
    google-chrome
    neovim
    yt-dlp
    gnome-keyring
    libsecret
    jdk
    linux-wifi-hotspot
    vscode
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
    base16-schemes
    davinci-resolve

    pass
    qtpass



    power-profiles-daemon
    # floorp #browser
    
    # wineWowPackages.stable
    # wineWowPackages.waylandFull
    # winetricks
    # protontricks
    # protonup
    # protonup-rs
    # protonup-qt
    # protonplus
    # lutris
    # heroic
    # bottles
    # mangohud
    # steamcmd
    # ntfs3g # to run steam games on ntfs drives with linux - drive needs to be mounted with ntfs-3g too, to make it work

    rose-pine-gtk-theme
    rose-pine-icon-theme
    bluez
    bluez-tools
    p7zip
    pavucontrol # PulseAudio Volume Control

  ];



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
