{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # StormDNS[](https://github.com/nullroute1970/StormDNS)
      # ──────────────────────────────────────────────────────────────
      stormdns = final.buildGoModule {
        pname = "stormdns";
        version = "v2026.04.12.234117-978faee";

        src = final.fetchFromGitHub {
          owner = "nullroute1970";
          repo = "StormDNS";
          rev = "87348df5b11f9e490262a713ca268734007af44f";  # latest as of 19 may 2026
          sha256 = "sha256-gvZrC/Ptub4HGRFAedfi7xlSqpzNxy453vz1OUOaU2o="; 
        };

        subPackages = [ "cmd/client" "cmd/server" ];

        # Standard for this clean Go project (no vendor/ folder)
        vendorHash = "sha256-EterKjJLXF+xu5elv21uoKZlOoUk4MZsvTavdj5UWx4=";

        doCheck = false;   # most DNS-tunnel tools fail tests in Nix sandbox

        # make the binaries have clean names
        postInstall = ''
          mv $out/bin/client $out/bin/stormdns-client 2>/dev/null || true
          mv $out/bin/server $out/bin/stormdns-server 2>/dev/null || true
        '';

        meta = {
          description = "fork of masterdns supposedly optimized for pc";
          homepage = "https://github.com/nullroute1970/StormDNS";
          license = final.lib.licenses.mit; 
          platforms = final.lib.platforms.linux;
          mainProgram = "stormdns-client";
        };
      };


    })
  ];
}

