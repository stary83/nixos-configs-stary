{ pkgs, lib, config, ... }:

{
  imports = [
    ./qemu-full.nix
    ./libvirt.nix
    ./bridge-utils.nix
    ./virt-manager.nix
    ./virt-viewer.nix
    ./edk2.nix
    ./vde2.nix
    ./dnsmasq.nix
    ./libguestfs.nix
    ./settings-for-virtual-machine.nix
  ];
  qemu-full.enable = 
    lib.mkDefault true;
  libvirt.enable =
    lib.mkDefault true;
  bridge-utils.enable =
    lib.mkDefault true;
  virt-manager.enable =
    lib.mkDefault true;
  virt-viewer.enable =
    lib.mkDefault true;
  edk2.enable =
    lib.mkDefault true;
  vde2.enable =
    lib.mkDefault true;
  dnsmasq.enable =
    lib.mkDefault true;
  libguestfs.enable =
    lib.mkDefault true;
  settings-for-virtual-machine.enable =
    lib.mkDefault true;
}
