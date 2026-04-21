{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # 1. dnstt (from bamsoftware's own git, not GitHub)
      # ──────────────────────────────────────────────────────────────
      dnstt = final.buildGoModule {
        pname = "dnstt";
        version = "2024-10-21";   # you can change to a real tag later

        src = final.fetchgit {
          url = "https://www.bamsoftware.com/git/dnstt.git";
          rev = "HEAD";                    # or pin a specific commit
          sha256 = "sha256-Y8FQOIXiMMEAMMyZs6YTpCm0LVtJxAac6LERJjVDNCk="; # ← run nix-build once, replace
        };

        vendorHash = "sha256-fWH2pwLRDemFZP3yqxG15YpvdtyIjJvpmLckhaloMvA=";
        
        # Build the main packages that actually exist in this repo
        # (no "cmd/" prefix)
        subPackages = [ "dnstt-client" "dnstt-server" ];

	doCheck = false;

        meta = {
          description = "DNS tunnel (client and server)";
          homepage = "https://www.bamsoftware.com/software/dnstt/";
          license = final.lib.licenses.gpl3Plus; # check actual license
	  platforms = final.lib.platforms.linux;
        };
      };
    })
  ];

  environment.systemPackages = with pkgs; [ 
    dnstt
  ];
}

