{ pkgs, lib, config, ... }: {

  options = {
    qemu-full.enable =
      lib.mkEnableOption "enables qemu-full";
  };

  config = lib.mkIf config.qemu-full.enable {
    environment.systemPackages = with pkgs; [
      qemu_full
    ];
  };
}
