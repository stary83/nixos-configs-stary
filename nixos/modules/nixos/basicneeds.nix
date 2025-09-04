{ pkgs, lib, config, ... }: {

  options = {
    basicneeds.enable = 
      lib.mkEnableOption "enables basicneeds";
  };

  config = lib.mkIf config.basicneeds.enable {
    environment.systemPackages = with pkgs; [
      vim
      wget
      tree
      curl
      vlc
      htop
      ffmpeg
      neofetch
    ];
  };
}
