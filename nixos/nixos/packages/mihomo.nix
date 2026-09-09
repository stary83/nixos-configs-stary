{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # mihomo (prebuilt, static Go binary)
      #
      # Same reasoning as sing-box-bin: v2rayN copies cores into
      # ~/.local/share/v2rayN/bin, so anything with a dynamic interpreter can
      # rot when its glibc is GC'd. mihomo is statically linked Go (no
      # PT_INTERP - verified), so it is immune.
      #
      # ARCH LEVEL: mihomo ships amd64 v1/v2/v3 builds (x86-64 baseline /
      # v2 SSE4.2 / v3 AVX2). This CPU is an i5-7200U (Kaby Lake) which does
      # support v3, but v1 is used deliberately: it is the safe default if the
      # config ever moves to another machine, and the difference for a proxy
      # is negligible. To switch, change the url to
      # mihomo-linux-amd64-v3-${version}.gz and update the hash.
      #
      # NOT TESTED AGAINST A REAL CONFIG: this machine has no mihomo/clash
      # profiles, so unlike sing-box I could not run `check` against a
      # v2rayN-generated yaml. 1.19.30 is one minor above the 1.19.29 that
      # ships in the v2rayN zip, so risk is low - but if a clash profile ever
      # fails to start, this is the first thing to roll back.
      # ──────────────────────────────────────────────────────────────
      mihomo = prev.stdenv.mkDerivation rec {
        pname = "mihomo";
        version = "1.19.30";

        src = prev.fetchurl {
          url = "https://github.com/MetaCubeX/mihomo/releases/download/v${version}/mihomo-linux-amd64-v1-v${version}.gz";
          hash = "sha256-y+VT0DGaQUvTo3LFl2olIVWyxIgrZrzoik1rupVxpVM=";
        };

        # the asset is a bare gzip of a single binary, not a tarball
        dontUnpack = true;
        nativeBuildInputs = [ prev.gzip ];

        # do not strip or patchelf: already static and self-contained
        dontConfigure = true;
        dontBuild = true;
        dontFixup = true;

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          gunzip -c $src > $out/bin/mihomo
          chmod 755 $out/bin/mihomo
          runHook postInstall
        '';

        passthru.updateScript = prev.nix-update-script { };

        meta = with prev.lib; {
          description = "Rule-based tunnel in Go (prebuilt static binary)";
          homepage = "https://github.com/MetaCubeX/mihomo";
          license = licenses.gpl3Only;
          sourceProvenance = with sourceTypes; [ binaryNativeCode ];
          platforms = [ "x86_64-linux" ];
          mainProgram = "mihomo";
        };
      };
    })
  ];
  # `with pkgs;` required - see note in singbox.nix (bare `mihomo` is an
  # undefined variable at module scope, not the overlay's attribute).
  environment.systemPackages = with pkgs; [ mihomo ];
}