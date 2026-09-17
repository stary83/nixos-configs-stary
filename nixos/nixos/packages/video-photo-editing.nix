{ pkgs, inputs, ... }:

let
  unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
in {
  environment.gnome.excludePackages = with pkgs; [
    # davinci-resolve # doesn't seem to be working
    kdePackages.kdenlive # video editing
    cinelerra # video editing
    losslesscut # FFmpeg GUI for extremely fast and lossless operations on video
    unstable.gimp
    darktable # only thing that can extract photo's from my old sony camera
  ];
}
