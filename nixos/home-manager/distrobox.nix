{ pkgs, ... }:

{
  programs.distrobox = {
    enable = true;
  };
  home.file.".config/distrobox/distrobox.ini".text = ''
    # ==============================================================================
    # Distrobox Manifest - Managed by Home Manager
    # ==============================================================================
    # Create containers with: distrobox assemble create
    # Destroy containers with: distrobox assemble rm

    [arch-vpn]
    image=archlinux:latest
    init=false
    root=true  # Required for TUN device access
    pull=true
    start_now=true
    additional_packages="git wget"
    # This is the key for VPN functionality
    additional_flags="--cap-add=NET_ADMIN --device=/dev/net/tun"

  '';
}
