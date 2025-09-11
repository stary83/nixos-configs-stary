{ pkgs, lib, config, ... }:

{
  imports = [
    ./virtual-machine-pkgs/qemu-full.nix
    ./virtual-machine-pkgs/libvirt.nix
    ./virtual-machine-pkgs/bridge-utils.nix
    ./virtual-machine-pkgs/virt-manager.nix
    ./virtual-machine-pkgs/virt-viewer.nix
    ./virtual-machine-pkgs/edk2.nix
    ./virtual-machine-pkgs/vde2.nix
    ./virtual-machine-pkgs/dnsmasq.nix
    ./virtual-machine-pkgs/libguestfs.nix
    ./virtual-machine-pkgs/settings-for-virtual-machine.nix
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
