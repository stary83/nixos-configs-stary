{ pkgs, lib, config, ... }:

{
  imports = [
    ./main-user.nix
    ./basicneeds.nix
    ./virtual-machine-pkgs/default.nix
    ./stylix.nix
  ];
  basicneeds.enable = true;

}
