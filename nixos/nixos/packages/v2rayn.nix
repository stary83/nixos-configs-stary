{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # v2rayN (Latest version - prebuilt Linux binary)
      # ──────────────────────────────────────────────────────────────
      v2rayn = final.stdenv.mkDerivation rec {
        pname = "v2rayN";
        version = "7.22.5";

        src = final.fetchurl {
          url = "https://github.com/2dust/v2rayN/releases/download/${version}/v2rayN-linux-64.zip";
          sha256 = "sha256-PZg9vQdqSn2Y/JYGtFoR6vQb2rjF1sG+4IfWwjqilj0=";
        };

        dontUnpack = true;

        nativeBuildInputs = with final; [
          unzip
          makeWrapper
          autoPatchelfHook
	  copyDesktopItems
        ];

        buildInputs = with final; [
	  stdenv.cc.cc.lib
          gtk3
          glib
          libGL
          fontconfig
          libX11
          libXrandr
          libXi
          libXcursor
          libXext
          libICE
          libSM
          icu
          openssl
          libpulseaudio
          dbus
          libsecret
        ];
        
	installPhase = ''
          runHook preInstall

          mkdir -p $out/bin $out/share/v2rayN $out/share/icons/hicolor/256x256/apps

          # Extract into a temporary directory
          unzip $src -d temp-extract

          # The actual content is inside v2rayN-linux-64/
          cp -r temp-extract/v2rayN-linux-64/* $out/share/v2rayN/

          # Make main binaries executable
          chmod +x $out/share/v2rayN/v2rayN
          chmod +x $out/share/v2rayN/bin/xray/xray
          chmod +x $out/share/v2rayN/bin/sing_box/sing-box
          chmod +x $out/share/v2rayN/bin/mihomo/mihomo

          # Install icon
          install -Dm644 $out/share/v2rayN/v2rayN.png $out/share/icons/hicolor/256x256/apps/v2rayN.png

          # Create wrapper
	  makeWrapper $out/share/v2rayN/v2rayN $out/bin/v2rayN \
            --prefix LD_LIBRARY_PATH : "${final.lib.makeLibraryPath buildInputs}" \
            --chdir $out/share/v2rayN \
            # --set DOTNET_GCHeapHardLimit 0x10000000

          runHook postInstall
        '';

	desktopItems = [
          (final.makeDesktopItem {
            name = "v2rayN";
            exec = "v2rayN";
            icon = "v2rayN";
            desktopName = "v2rayN";
            genericName = "Proxy Client";
            comment = "Powerful GUI client for Xray / sing-box / mihomo";
            categories = [ "Network" "Utility" ];
            terminal = false;
            startupWMClass = "v2rayN";
          })
        ];

        meta = {
          description = "v2rayN - Powerful GUI client for Xray / sing-box";
          homepage = "https://github.com/2dust/v2rayN";
          license = final.lib.licenses.gpl3Plus;
          platforms = [ "x86_64-linux" ];
          mainProgram = "v2rayN";
        };
      };
    })
  ];

}
