{ ... }:
{

  imports = [
    ./main-user.nix
  ];

  main-user.enable = true;
  main-user.userName = "stary";

}
