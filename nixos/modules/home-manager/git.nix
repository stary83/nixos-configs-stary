{ pkgs, lib, config, ... }: {

  options = {
    git.enable = 
      lib.mkEnableOption "enables git";
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      userName = "stary83";
      userEmail = "visionarygambit@gmail.com";
    };
  };
}
