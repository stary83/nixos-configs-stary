{ pkgs, lib, config, ... }: {

  options = {
    git.enable = 
      lib.mkEnableOption "enables git";
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
	  name = "stary83";
	  email = "visionarygambit@gmail.com";
	};
      };
    };
  };
}
