{ pkgs, lib, config, ... }: {

  options = {
    vde2.enable =
      lib.mkEnableOption "enables vde2";
  };

  config = lib.mkIf config.vde2.enable {
    environment.systemPackages = with pkgs; [
      vde2
    ];
  };
}
