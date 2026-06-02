{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      sni-spoofing-go = prev.stdenv.mkDerivation rec {
        pname = "sni-spoofing-go";
        version = "0.4.0";

        src = prev.fetchurl {
          url = "https://github.com/aleskxyz/SNI-Spoofing-Go/releases/download/v${version}/sni-spoofing-linux-amd64";
          hash = "sha256-PfCEJxWQVrqp2q9apyOjT58d3KTHj58RhDYd/Qyr1E8=";
        };

        dontUnpack = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          cp $src $out/bin/sni-spoofing-go
          chmod +x $out/bin/sni-spoofing-go

          runHook postInstall
        '';

        meta = with prev.lib; {
          description = "High-performance Go implementation of SNI-Spoofing DPI bypass tool";
          homepage = "https://github.com/aleskxyz/SNI-Spoofing-Go";
          license = licenses.gpl3Only;
          maintainers = with maintainers; [ ];
          platforms = [ "x86_64-linux" ];
          mainProgram = "sni-spoofing-go";
        };
      };
    })
  ];

}
