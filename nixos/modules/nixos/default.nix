{ pkgs, lib, config, ... }:

{
  imports = [
    ./main-user.nix
    ./basicneeds.nix
    ./virtual-machine-pkgs/default.nix
    ./stylix.nix
    ./nixvim.nix
  ];
  basicneeds.enable = true;

}
