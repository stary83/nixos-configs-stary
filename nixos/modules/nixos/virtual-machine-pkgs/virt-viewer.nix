{ pkgs, lib, config, ... }: {

  options = {
    virt-viewer.enable =
      lib.mkEnableOption "enables virt-viewer";
  };

  config = lib.mkIf config.virt-viewer.enable {
    environment.systemPackages = with pkgs; [
      virt-viewer
    ];
  };
}
