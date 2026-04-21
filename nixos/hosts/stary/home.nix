{
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../../home-manager/default.nix
  ];

  home.username = "stary";
  home.homeDirectory = "/home/stary";
  home.stateVersion = "25.05"; # DO NOT EDIT
}
