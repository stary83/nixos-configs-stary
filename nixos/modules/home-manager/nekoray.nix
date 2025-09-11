{ pkgs, lib, config, ... }: {

  options = {
    nekoray.enable =
      lib.mkEnableOption "enables nekoray";
  };

  config = lib.mkIf config.nekoray.enable {
    home.packages = with pkgs; [
      nekoray
    ];
  };
}
