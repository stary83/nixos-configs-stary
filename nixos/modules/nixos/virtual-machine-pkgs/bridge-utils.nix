{ pkgs, lib, config, ... }: {

  options = {
    bridge-utils.enable =
      lib.mkEnableOption "enables bridge-utils";
  };

  config = lib.mkIf config.bridge-utils.enable {
    environment.systemPackages = with pkgs; [
      bridge-utils
    ];
  };
}
