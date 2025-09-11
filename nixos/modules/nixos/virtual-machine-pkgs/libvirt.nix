{ pkgs, lib, config, ... }: {

  options = {
    libvirt.enable =
      lib.mkEnableOption "enables libvirt";
  };

  config = lib.mkIf config.libvirt.enable {
    environment.systemPackages = with pkgs; [
      libvirt
    ];
  };
}
