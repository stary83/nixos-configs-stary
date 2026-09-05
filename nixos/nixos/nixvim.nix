{ config , ... }: {

  programs.nixvim = {
    enable = true;
    defaultEditor =  true;
    colorschemes = {
      gruvbox.enable = true;
    };
    plugins = {
      # nvim-tree = {
      #  enable = true;
	    #  openOnSetup = true;
      # };
    };

  };
 

}

