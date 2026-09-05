{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # MasterDnsVPN[](https://github.com/masterking32/MasterDnsVPN)
      # ──────────────────────────────────────────────────────────────
      masterDnsVpn = final.buildGoModule {
        pname = "masterDnsVpn";
        version = "v2026.04.12.234117-978faee";

        src = final.fetchFromGitHub {
          owner = "masterking32";
          repo = "MasterDnsVPN";
          rev = "27c7e11ce9eb51d7db36b34188502e524a3184db";
          sha256 = "sha256-WEND1op/Pdc2nYbFfZoIhi9jzA8lTI8Ib4ltNYQ9hkY="; 
        };

        subPackages = [ "cmd/client" "cmd/server" ];

        vendorHash = "sha256-X0TpheIBmhT0tbNf5FEnUW1faIgY2oTxMfoRUDTjn34=";

        doCheck = false;   # most DNS-tunnel tools fail tests in Nix sandbox

        postInstall = ''
          mv $out/bin/client $out/bin/masterdnsvpn-client 2>/dev/null || true
          mv $out/bin/server $out/bin/masterdnsvpn-server 2>/dev/null || true
        '';

        meta = {
          description = "Advanced DNS tunneling VPN (optimized beyond DNSTT)";
          homepage = "https://github.com/masterking32/MasterDnsVPN";
          license = final.lib.licenses.unfree; 
          platforms = final.lib.platforms.linux;
          mainProgram = "masterdnsvpn-client";
        };
      };


    })
  ];
  
  environment.systemPackages = with pkgs; [
    masterDnsVpn
  ];
}

