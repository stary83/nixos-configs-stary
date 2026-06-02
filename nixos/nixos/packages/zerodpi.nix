{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      zerodpi = prev.stdenv.mkDerivation rec {
        pname = "zerodpi";
        version = "0.1.0"; # tag: v0.1.0-20260525T092918Z-bd03a3d79aa4

        src = prev.fetchurl {
          url = "https://github.com/nullroute1970/ZeroDPI/releases/download/v20260529T190854Z-e891ea8ca03b/zerodpi-linux-x86_64.tar.gz";
          hash = "sha256-VsA9BkxENO810eFbaggt89hzZ81yINC3nGm+CITbhCM=";
        };

	# autoPatchelfHook will fix the binary's internal library paths
        nativeBuildInputs = [ prev.autoPatchelfHook ];

        # Libraries the ZeroDPI binary needs at runtime
        buildInputs = with prev; [
          libnetfilter_queue
          stdenv.cc.cc.lib  # provides libstdc++.so.6
          zlib
          glibc
        ];

        sourceRoot = ".";

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin $out/share/zerodpi

          # Copy all important files to the share directory
          cp zerodpi $out/share/zerodpi/

          # Symlink the binary into PATH
          ln -s $out/share/zerodpi/zerodpi $out/bin/zerodpi
          chmod +x $out/share/zerodpi/zerodpi

          runHook postInstall
        '';

        meta = with prev.lib; {
          description = "Cross-platform DPI bypass proxy (Rust)";
          homepage = "https://github.com/nullroute1970/ZeroDPI";
          license = licenses.mit;
          maintainers = with maintainers; [ ];
          platforms = [ "x86_64-linux" ];
          mainProgram = "zerodpi";
        };
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    zerodpi
  ];
}
