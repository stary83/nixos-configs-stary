{ config, pkgs, inputs, ... }:
let
  # stable = inputs.nixpkgs-stable.legacyPackages.x86_64-linux;
  unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;

in {
  nixpkgs = {
    overlays = [
      (final: prev: {
      })
    ];
  };
}
