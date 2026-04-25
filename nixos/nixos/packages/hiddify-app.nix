{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # Hiddify App (AppImage from GitHub Releases)
      # ──────────────────────────────────────────────────────────────
      hiddify-app = final.stdenv.mkDerivation {
        pname = "hiddify-app";
        version = "4.1.1";

        src = final.fetchurl {
          url = "https://github.com/hiddify/hiddify-app/releases/download/v4.1.1/Hiddify-Linux-x64-AppImage.AppImage";
          sha256 = "sha256-6yu2wIlxuY4tCgH8W2R+KboXsWYRScyfl+2g53v1vcM="; # ← placeholder, replace after first build
        };

        dontUnpack = true;
        dontBuild = true;

        nativeBuildInputs = [ final.autoPatchelfHook ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          cp $src $out/bin/hiddify-app
          chmod +x $out/bin/hiddify-app

          runHook postInstall
        '';

        meta = {
          description = "Hiddify - Multi-platform proxy / VPN client (Sing-box, Xray, Reality, etc.)";
          homepage = "https://github.com/hiddify/hiddify-app";
          license = final.lib.licenses.unfree;
          platforms = final.lib.platforms.linux;
          mainProgram = "hiddify-app";
        };
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    hiddify-app
  ];
}
