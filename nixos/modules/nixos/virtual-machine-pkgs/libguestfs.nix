{ pkgs, lib, config, ... }: {

  options = {
    libguestfs.enable =
      lib.mkEnableOption "enables libguestfs";
  };

  config = lib.mkIf config.libguestfs.enable {
    environment.systemPackages = with pkgs; [
      libguestfs
    ];
  };
}
