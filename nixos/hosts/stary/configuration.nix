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
    ../../nixos/networking.nix
    ../../nixos/website.nix
    ../../nixos/hardware.nix
    ../../nixos/programs.nix
    ../../nixos/user.nix
    ../../nixos/services.nix
    ../../nixos/general-settings.nix
    ../../nixos/nixvim.nix
    ../../nixos/stylix.nix
    ../../nixos/virtual-machine.nix
    ../../nixos/packages/envpkgs.nix
    ../../nixos/packages/external.nix
    # --------------------- nixpkgs overlays -------------------------
    ../../nixos/packages/dnstt.nix
    ../../nixos/packages/vaydns.nix
    ../../nixos/packages/masterDnsVpn.nix
    # ----------------------------------------------------------------
  ];

  # DO NOT EDIT
  system.stateVersion = "24.11";

}
