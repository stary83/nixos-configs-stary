{ pkgs, lib, config, ... }: {

  options = {
    virt-manager.enable =
      lib.mkEnableOption "enables virt-manager";
  };

  config = lib.mkIf config.virt-manager.enable {
    programs.virt-manager.enable = true;
  };
}
