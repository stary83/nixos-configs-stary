{ pkgs, lib, config, ... }:

{
  imports = [
    ./main-user.nix
    ./basicneeds.nix

  ];
  basicneeds.enable = true;

}
