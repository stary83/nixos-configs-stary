{ config , ... }: {

  programs.nixvim = {
    enable = true;
    defaultEditor =  true;
    colorschemes = {
      gruvbox = {
        lazyLoad = {
          enable = true;
	  settings = {};
	};
      luaConfig = {};
      };
    };

  };
 

}
