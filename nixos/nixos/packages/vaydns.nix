{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # vaydns (https://github.com/net2share/vaydns)
      # ──────────────────────────────────────────────────────────────
      vaydns = final.buildGoModule {
        pname = "vaydns";
        version = "0.2.8";   # you can update the date later

        src = final.fetchFromGitHub {
          owner = "net2share";
          repo = "vaydns";
          rev = "a0ff70110d5e96686ab8f4c8e1c44cd09be07a75";                    # ← change to a pinned commit later
          sha256 = "sha256-5AdqFKc1ccCvlEGzx4qrW2ysxejtXkyVSqCBcJ33qmM="; # ← will be fixed on first build
        };

        # These are the two real main packages (exactly as in the README)
        subPackages = [ "vaydns-client" "vaydns-server" ];

        # Standard settings for this kind of project (no vendor/ folder)
        vendorHash = "sha256-LWi4YP9jMOi5/liSU7v7TPVmsMIrH6Iy2aRqgLfRJpM=";   # ← Nix will tell you the real one on first build

        doCheck = false;   # most tunnel tools fail tests in the Nix sandbox

        meta = {
          description = "Userspace DNS tunnel (fork of dnstt with DoH/DoT + optimizations)";
          homepage = "https://github.com/net2share/vaydns";
          license = final.lib.licenses.cc0;
          platforms = final.lib.platforms.linux;
        };
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    vaydns
  ];
}
