{ pkgs, lib, config, ... }:

{
  imports = [
    ./gpg.nix
    ./git.nix
    ./nekoray.nix
  ];
  gpg.enable = true;
  git.enable = true;
  nekoray.enable = true;

}
