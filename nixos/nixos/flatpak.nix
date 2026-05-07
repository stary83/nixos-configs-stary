{ config, pkgs, lib, ... }:

{

  # Enable the base Flatpak service + nix-flatpak management
  services.flatpak = {
    enable = true;

    #update = {
    #  onActivation = true;      # update flatpaks on every nixos-rebuild
    #};

    # uninstallUnmanaged = true;   # WARNING: removes any flatpaks you installed manually with `flatpak install`

    #packages = [
    #  "org.telegram.desktop"
    
      # You can also pin a specific commit or use a flatpakref:
      # { appId = "com.example.App"; origin = "flathub"; commit = "abc123..."; }
    #];
    

    #remotes = [
    #  { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
    #];
    # Example: add extra remotes if needed
    # remotes = [
    #   { name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo"; }
    # ];

  };

}
