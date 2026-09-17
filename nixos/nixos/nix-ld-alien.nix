{ config, pkgs, inputs, ... }:
{ 
  environment.systemPackages = with pkgs; [
    inputs.nix-alien.packages.${stdenv.hostPlatform.system}.default
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  ];
}
