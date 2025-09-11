{ pkgs, lib, config, ... }:

{
  imports = [
    ./main-user.nix
    ./basicneeds.nix
    ./virtual-machine-pkgs.nix
  ];
  basicneeds.enable = true;

}
