{ pkgs, lib, config, ... }:

{
  imports = [
    ./gpg.nix
    ./git.nix
  ];
  git.enable = true;

}
