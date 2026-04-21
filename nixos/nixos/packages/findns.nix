{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # 1. findns (pre-built binary from GitHub Releases)
      # ──────────────────────────────────────────────────────────────
      findns = final.stdenv.mkDerivation rec {
        pname = "findns";
        version = "0.2.2.1";

        src = final.fetchurl {
          url = "https://github.com/SamNet-dev/findns/releases/download/v${version}/findns-linux-amd64";
          hash = "sha256-FlOEMeVQjKX5APeNoZwln4reath2uHAPPMENM/6tdDQ=";
        };

        # We're installing a pre-built binary, so no build phase needed
        dontUnpack = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          cp $src $out/bin/findns
          chmod +x $out/bin/findns
          runHook postInstall
        '';

        meta = with final.lib; {
          description = "DNS tunnel client and resolver testing tool";
          homepage = "https://github.com/SamNet-dev/findns";
          license = licenses.gpl3Only;
          maintainers = with maintainers; [ ];
          platforms = [ "x86_64-linux" ];
          mainProgram = "findns";
        };
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    findns
  ];
}
