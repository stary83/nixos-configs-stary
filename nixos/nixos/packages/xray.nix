{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # Xray-core (latest pre-built binary from GitHub Releases)
      # ──────────────────────────────────────────────────────────────
      xray-core = prev.stdenv.mkDerivation rec {
        pname = "xray-core";
        version = "26.3.27";  # Latest stable release as of May 2026

        src = prev.fetchurl {
          url = "https://github.com/XTLS/Xray-core/releases/download/v${version}/Xray-linux-64.zip";
          hash = "sha256-I82a+Td0TZd3buNeytSXLPSyEJ0eD+a+mTBGdgj3yK4="; # ← REPLACE THIS
        };

        nativeBuildInputs = [ prev.unzip ];

        # The ZIP archive contains the 'xray' binary at its root
        sourceRoot = ".";

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          cp xray $out/bin/xray
          chmod +x $out/bin/xray
          runHook postInstall
        '';

        meta = with prev.lib; {
          description = "The best v2ray-core, with XTLS support, fully compatible configuration";
          homepage = "https://github.com/XTLS/Xray-core";
          license = licenses.mpl20; # From the project's license file
          platforms = [ "x86_64-linux" ];
          mainProgram = "xray";
        };
      };
    })
  ];

}
