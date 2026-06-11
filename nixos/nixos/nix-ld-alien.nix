{ config, pkgs, inputs, ... }:
{ 
  environment.systemPackages = with pkgs; [
    inputs.nix-alien.packages.${stdenv.hostPlatform.system}.default
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # --- windscribe -----------------------------------------------
    brotli.lib 
    fontconfig.lib 
    freetype.out 
    glib.out 
    harfbuzz.out 
    kdePackages.wayland.out 
    libGL.out 
    libdrm.out 
    libgcc.lib
    libx11.out 
    libxcb-cursor.out
    libxcb-image.out
    libxcb-keysyms.out
    libxcb-render-util.out
    libxcb-util.out
    libxcb-wm.out 
    libxcb.out
    libxkbcommon.out
    pcre2.out 
    zstd.out
    # --- v2rayN ---------------------------------------------------
    glibc
    stdenv.cc.cc.lib
    icu               
    libGL
    libX11
    libxcb
    fontconfig
    freetype
  ];
}
