{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      dns-hop = prev.appimageTools.wrapType2 rec {
        pname = "dns-hop";
        version = "2.4.2";

        src = prev.fetchurl {
          url = "https://github.com/center2055/DNS-Hop/releases/download/v${version}/DNS-Hop-AppImage-v${version}-x86_64.AppImage";
          hash = "sha256-vRqok6QP0BV5srOU+Gn7FdFNHd7YVyWvQnlrf0Gyh9M="; 
        };

        extraPkgs = pkgs: with pkgs; [
          fuse
          icu
          libnotify
          libappindicator-gtk3
          xdg-utils
        ];

        profile = ''
          cd "$HOME" 2>/dev/null || cd /
        '';

        meta = with prev.lib; {
          description = "DNS-Hop – a DNS-over-HTTPS proxy with smart routing";
          homepage = "https://github.com/center2055/DNS-Hop";
          license = licenses.gpl3Only; # verify actual license
          maintainers = with maintainers; [ ];
          platforms = [ "x86_64-linux" ];
          mainProgram = "dns-hop";
        };
      };
    })
  ];

  # FUSE is required for AppImage extraction (build-time only)
  boot.kernelModules = [ "fuse" ];
  programs.fuse.userAllowOther = true;
  environment.systemPackages = with pkgs; [
    fuse
    fuse3
    dns-hop
  ];
}