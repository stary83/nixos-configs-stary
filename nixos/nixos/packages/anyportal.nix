{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # AnyPortal – pre-built binary from GitHub Releases (zip)
      # ──────────────────────────────────────────────────────────────
      anyportal = final.stdenv.mkDerivation rec {
        pname = "anyportal";
        version = "0.6.31-105";

        src = final.fetchurl {
          url = "https://github.com/AnyPortal/AnyPortal/releases/download/v0.6.31%2B105/anyportal-linux.zip";
          hash = "sha256-RR9kvl24GFvOEiAH8NMVc/J5ma2a1CbgwkA8FnIF9dc="; # ← REPLACE THIS AFTER FIRST BUILD
        };

        nativeBuildInputs = [ final.autoPatchelfHook final.unzip ];

        # The zip likely contains the executable directly (no top‑level folder)
        # so we set sourceRoot to the current directory to keep things simple.
        sourceRoot = "anyportal-linux";

	autoPatchelfLibs = [ "$out/share/anyportal/lib" ];

        installPhase = ''
          runHook preInstall

          # Create a self‑contained app directory
          mkdir -p $out/share/anyportal
          cp -r . $out/share/anyportal/

          # Make the binary accessible from $PATH
          mkdir -p $out/bin
          ln -s $out/share/anyportal/anyportal $out/bin/anyportal
          chmod +x $out/share/anyportal/anyportal

          runHook postInstall
        '';



        meta = with final.lib; {
          description = "AnyPortal VPN / proxy client";
          homepage = "https://github.com/AnyPortal/AnyPortal";
          license = licenses.unfree; # Verify the actual license
          platforms = platforms.linux;
          mainProgram = "anyportal";
        };
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    anyportal
  ];
}
