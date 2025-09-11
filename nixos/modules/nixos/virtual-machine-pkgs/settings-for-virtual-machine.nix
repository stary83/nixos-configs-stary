{ pkgs, lib, config, ... }: {

  options = {
    settings-for-virtual-machine.enable =
      lib.mkEnableOption "enables settings-for-virtual-machine";
  };

  config = lib.mkIf config.settings-for-virtual-machine.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
    boot.extraModprobeConfig = "options kvm_intel nested=1";
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
