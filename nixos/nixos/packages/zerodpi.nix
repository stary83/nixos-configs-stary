{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      zerodpi = prev.stdenv.mkDerivation rec {
        pname = "zerodpi";
        version = "0.1.0"; 

        src = prev.fetchurl {
          url = "https://github.com/nullroute1970/ZeroDPI/releases/download/v20260616T042633Z-88d22f0f994d/zerodpi-linux-x86_64.tar.gz";
          hash = "sha256-BvEvl2qC8r/EO5hqkprCbKtJulsgmt/oXmp9udltYRM=";
        };

        nativeBuildInputs = [ prev.autoPatchelfHook ];

        buildInputs = with prev; [
          libnetfilter_queue
          stdenv.cc.cc.lib  
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
