{ pkgs, lib, ... }:
{

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  boot.extraModprobeConfig = "options kvm_intel nested=1";
  virtualisation.spiceUSBRedirection.enable = true;

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    edk2
    bridge-utils
    dnsmasq
    libguestfs
    libvirt
    qemu_full
    vde2
    virt-viewer
  ];

}
