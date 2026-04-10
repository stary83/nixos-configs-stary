{ pkgs, ... }:{
  home.packages = with pkgs; [ 
    #heroic
    #steam
    wineWowPackages.full
    mesa
    libGLU
    #protonup-qt # Install and manage Proton-GE and Luxtorpeda for Steam and Wine-GE for Lutris with this graphical user interface
    #bottles
  ];
  programs = {
    lutris = {
      enable = true;
    };
  };

  #home.file."path" = {
  #  source = relative path to source;
  #};

}
