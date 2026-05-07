{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {


      # ──────────────────────────────────────────────────────────────
      # KevinNet DNS (prebuilt Python/Tkinter GUI)
      # ──────────────────────────────────────────────────────────────
      kevinnet-dns = final.stdenv.mkDerivation rec {
        pname = "kevinnet-dns";
        version = "3.0.8";

        src = final.fetchurl {
          url = "https://github.com/kamalalhagh/kevinnet-dns/releases/download/v${version}/KevinNet_Linux_x64";
          sha256 = "sha256-XO/i+mynZGG9wQN8m36rdm4CMlZLDZmqwmzA2g5LPkk="; # ← replace after first build
        };

        dontUnpack = true;
        dontBuild = true;

        nativeBuildInputs = [
          final.autoPatchelfHook
          final.makeWrapper
        ];

        buildInputs = with final; [
          stdenv.cc.cc.lib
          zlib
          openssl
          gtk3
          glib
          dbus
          libGL
          xorg.libX11
          xorg.libXrandr
          xorg.libXcursor
          xorg.libXi
          fontconfig
          freetype
          alsa-lib
          udev
          tk
          tcl
          xorg.libXScrnSaver
          python3
        ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          cp $src $out/bin/kevinnet-dns
          chmod +x $out/bin/kevinnet-dns

          # Strong wrapper based on maintainer’s suggestion + NixOS requirements
          wrapProgram $out/bin/kevinnet-dns \
            --prefix LD_LIBRARY_PATH : "${final.lib.makeLibraryPath [ final.tk final.tcl final.stdenv.cc.cc.lib final.glib ]}" \
            --set TCL_LIBRARY "${final.tcl}/lib/tcl${final.tcl.release}" \
            --set TK_LIBRARY  "${final.tk}/lib/tk${final.tk.release}" \
            --set PYTHONHOME "${final.python3}" \
            --set LD_PRELOAD "${final.stdenv.cc.cc.lib}/lib/libstdc++.so.6" \
            --prefix PATH : "${final.tk}/bin"

          runHook postInstall
        '';

        meta = {
          description = "KevinNet DNS - GUI DNS tunnel client";
          homepage = "https://github.com/kamalalhagh/kevinnet-dns";
          license = final.lib.licenses.unfree;
          platforms = final.lib.platforms.linux;
          mainProgram = "kevinnet-dns";
        };
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    kevinnet-dns
  ];


}
