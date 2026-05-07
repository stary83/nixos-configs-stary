{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      stormdns = prev.stdenv.mkDerivation rec {
        pname = "stormdns";
        version = "2026.04.26.153956-15aedd9";

        src = prev.fetchurl {
          url = "https://github.com/nullroute1970/StormDNS/releases/download/v${version}/StormDNS_Client_Linux_AMD64.tar.gz";
          hash = "sha256-VmBi6VV4L3vsDrJPw1OIm5C+ZBYLn0VcBkVhzufu/F8=";
        };

        sourceRoot = ".";

        # The archive contains a single binary named "StormDNS_Client"
        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          cp StormDNS_Client_Linux_AMD64_v${version} $out/bin/stormdns
          chmod +x $out/bin/stormdns
          runHook postInstall
        '';

        meta = with prev.lib; {
          description = "StormDNS client for encrypted DNS";
          homepage = "https://github.com/nullroute1970/StormDNS";
          license = licenses.gpl3Only;
          maintainers = with maintainers; [ ];
          platforms = [ "x86_64-linux" ];
          mainProgram = "stormdns";
        };
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    stormdns
  ];
}
