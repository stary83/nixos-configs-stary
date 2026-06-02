{ pkgs, ... }:

let
  # 1. Fetch the raw binaries (no patching – the FHS environment will provide everything)
  client-bin = pkgs.stdenv.mkDerivation {
    pname = "psiphon-client-raw";
    version = "unstable-2026-04-30";
    src = pkgs.fetchurl {
      url = "https://github.com/Psiphon-Labs/psiphon-tunnel-core-binaries/raw/refs/heads/master/linux/psiphon-tunnel-core-x86_64";
      hash = "sha256-zZipcga8SH22gJxlcgvRFw1ALdaIEK6SH5UJ4hNc65o="; # ← replace
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/psiphon-tunnel-core
      chmod +x $out/bin/psiphon-tunnel-core
    '';
  };

  server-bin = pkgs.stdenv.mkDerivation {
    pname = "psiphond-raw";
    version = "unstable-2026-04-30";
    src = pkgs.fetchurl {
      url = "https://github.com/Psiphon-Labs/psiphon-tunnel-core-binaries/raw/refs/heads/master/psiphond/psiphond";
      hash = "sha256-SuWtnbDhEzCe4/znpoooDnqlZy5qNBTeQQdcGWhc08o="; # ← replace
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/psiphond
      chmod +x $out/bin/psiphond
    '';
  };

in
{
  nixpkgs.overlays = [
    (final: prev: {
      # 2. Wrap the client in an FHS environment → command “psiphon-tunnel”
      psiphon-tunnel = final.buildFHSEnv {
        name = "psiphon-tunnel";
        runScript = "${client-bin}/bin/psiphon-tunnel-core";
        targetPkgs = pkgs: with pkgs; [
          glibc
          zlib
          openssl
          stdenv.cc.cc.lib
          bash
          coreutils
        ];
      };

      # 3. Wrap psiphond in an FHS environment → command “psiphond”
      psiphond = final.buildFHSEnv {
        name = "psiphond";
        runScript = "${server-bin}/bin/psiphond";
        targetPkgs = pkgs: with pkgs; [
          glibc
          zlib
          openssl
          stdenv.cc.cc.lib
          bash
          coreutils
        ];
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    psiphon-tunnel
    psiphond
  ];

  networking.firewall.allowedTCPPorts = [ 8080 1080 ];
}
