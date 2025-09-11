{ pkgs, lib, config, ... }: {

  options = {
    edk2.enable =
      lib.mkEnableOption "enables edk2";
  };

  config = lib.mkIf config.edk2.enable {
    environment.systemPackages = with pkgs; [
      edk2
    ];
  };
}
