{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # SenPaiScanner – pre-built binary from GitHub Releases
      # ──────────────────────────────────────────────────────────────
      senpai-scanner = final.stdenv.mkDerivation rec {
        pname = "senpai-scanner";
        version = "0.5.0";

        src = final.fetchurl {
          url = "https://github.com/MatinSenPai/SenPaiScanner/releases/download/v${version}/senpaiscanner-linux-amd64";
          hash = "sha256-WxcxRitonB2k05GZtGOrusmY/IVCxdA3XF+YzxafS0I="; # ← REPLACE THIS
        };

        dontUnpack = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          cp $src $out/bin/senpai-scanner
          chmod +x $out/bin/senpai-scanner
          runHook postInstall
        '';

        meta = with final.lib; {
          description = "SenPaiScanner – a network scanning tool";
          homepage = "https://github.com/MatinSenPai/SenPaiScanner";
          license = licenses.mit; # check actual license
          maintainers = with maintainers; [ ];
          platforms = [ "x86_64-linux" ];
          mainProgram = "senpai-scanner";
        };
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    senpai-scanner
  ];
}
