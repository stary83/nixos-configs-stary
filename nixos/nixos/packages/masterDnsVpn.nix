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
          rev = "aff170eee0ad829519f60c56432e2f45d0dacc11";  # latest as of April 2026 (pin this)
          sha256 = "sha256-7uLxqvsd0e0LhyI0MHKYwKjqebhL+LYVbJ9SZ7boarY="; # ← will be fixed on first build
        };

        # Exact build targets from the official README
        subPackages = [ "cmd/client" "cmd/server" ];

        # Standard for this clean Go project (no vendor/ folder)
        vendorHash = "sha256-X0TpheIBmhT0tbNf5FEnUW1faIgY2oTxMfoRUDTjn34=";   # ← Nix will give you the real one on first build

        doCheck = false;   # most DNS-tunnel tools fail tests in Nix sandbox

        # Optional: make the binaries have clean names (recommended)
        postInstall = ''
          mv $out/bin/client $out/bin/masterdnsvpn-client 2>/dev/null || true
          mv $out/bin/server $out/bin/masterdnsvpn-server 2>/dev/null || true
        '';

        meta = {
          description = "Advanced DNS tunneling VPN (optimized beyond DNSTT)";
          homepage = "https://github.com/masterking32/MasterDnsVPN";
          license = final.lib.licenses.unfree;  # check LICENSE if you need strict licensing
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
