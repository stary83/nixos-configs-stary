{ pkgs, lib, config, ... }: {

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "stary83";
	email = "visionarygambit@gmail.com";
      };
    };
  };
}
