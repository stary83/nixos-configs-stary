{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      aether = prev.stdenv.mkDerivation rec {
        pname = "aether";
        version = "1.6.0";

        src = prev.fetchurl {
          url = "https://github.com/CluvexStudio/Aether/releases/download/v${version}/aether-linux-x86_64.tar.gz";
          hash = "sha256-Bt3GIp5IMDmwQwNvmoKjVpC3B5EG/c6lbLjQpZwttHQ=";
        };

        sourceRoot = ".";

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          cp aether $out/bin/aether
          chmod +x $out/bin/aether
          runHook postInstall
        '';

        meta = with prev.lib; {
          description = "Aether – a cross‑platform VPN/proxy client";
          homepage = "https://github.com/CluvexStudio/Aether";
          license = licenses.unfree;
          maintainers = with maintainers; [ ];
          platforms = [ "x86_64-linux" ];
          mainProgram = "aether";
        };
      };
    })
  ];

  environment.systemPackages = with pkgs; [ aether ];
}