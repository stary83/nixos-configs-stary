{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      onionhop = prev.appimageTools.wrapType2 rec {
        pname = "onionhop";
        version = "3.3.0";

        src = prev.fetchurl {
          url = "https://github.com/center2055/OnionHop/releases/download/v${version}/OnionHop-x86_64.AppImage";
          hash = "sha256-mEPLdrs5IIOKjz0RFdnbuK+GxAHTX5608eiHcWbzKzw="; 
        };

        extraPkgs = pkgs: with pkgs; [
          fuse
          libnotify
          libappindicator-gtk3
          xdg-utils
	  icu
        ];

        profile = ''
          cd "$HOME" 2>/dev/null || cd /
        '';

        meta = with prev.lib; {
          description = "OnionHop – an onion routing / circumvention tool";
          homepage = "https://github.com/center2055/OnionHop";
          license = licenses.gpl3Only;
          maintainers = with maintainers; [ ];
          platforms = [ "x86_64-linux" ];
          mainProgram = "onionhop";
        };
      };
    })
  ];

  boot.kernelModules = [ "fuse" ];
  programs.fuse.userAllowOther = true;
  environment.systemPackages = with pkgs; [
    fuse
    fuse3
    onionhop
  ];
}
