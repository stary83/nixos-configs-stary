{
  pkgs,
  inputs,
  ...
}:
{

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  imports = [
    ./hardware-configuration.nix
    ./device-specific.nix
    ../../nixos/graphics.nix
    ../../nixos/boot.nix
    ../../nixos/nix.nix
    ../../nixos/flatpak.nix
    ../../nixos/security.nix
    ../../nixos/networking.nix
    # ../../nixos/website.nix
    ../../nixos/hardware.nix
    ../../nixos/programs.nix
    ../../nixos/users.nix
    ../../nixos/services.nix
    ../../nixos/general-settings.nix
    ../../nixos/nixvim.nix
    ../../nixos/stylix.nix
    ../../nixos/virtual-machine.nix
    ../../nixos/packages/envpkgs.nix
    ../../nixos/packages/overlaysforpkgsthatarentworking.nix
    ../../nixos/podman.nix
    ../../nixos/docker.nix
    ../../nixos/nix-ld-alien.nix
    # --------------------- nixpkgs overlays -------------------------
    # currently all are network related and imported into networking.nix
    # ----------------------------------------------------------------
  ];

  # DO NOT EDIT
  system.stateVersion = "24.11";

}
