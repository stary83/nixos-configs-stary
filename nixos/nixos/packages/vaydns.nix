{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # vaydns (https://github.com/net2share/vaydns)
      # ──────────────────────────────────────────────────────────────
      vaydns = final.buildGoModule {
        pname = "vaydns";
        version = "0.2.8";  

        src = final.fetchFromGitHub {
          owner = "net2share";
          repo = "vaydns";
          rev = "a0ff70110d5e96686ab8f4c8e1c44cd09be07a75";                    
          sha256 = "sha256-5AdqFKc1ccCvlEGzx4qrW2ysxejtXkyVSqCBcJ33qmM="; 
        };

        subPackages = [ "vaydns-client" "vaydns-server" ];

        vendorHash = "sha256-LWi4YP9jMOi5/liSU7v7TPVmsMIrH6Iy2aRqgLfRJpM="; 

        doCheck = false;

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
