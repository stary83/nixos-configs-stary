{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # v2ray-rules-dat  (Loyalsoldier)  — geoip.dat + geosite.dat
      #
      # WHY THIS EXISTS AS A SEPARATE PACKAGE
      #
      # pkgs.v2ray-rules-dat does NOT exist in nixpkgs at any recent pin
      # (verified: `nix-instantiate --eval 'p ? v2ray-rules-dat'` -> false
      # on 26.05, and the by-name/ tree has no such directory). What nixpkgs
      # DOES have is the two upstream source repos split apart:
      #
      #   pkgs.v2ray-geoip                  -> share/v2ray/geoip.dat
      #   pkgs.v2ray-domain-list-community  -> share/v2ray/geosite.dat
      #
      # Those are the *inputs* Loyalsoldier recompiles, not the same artefacts:
      # v2ray-geoip's geoip.dat is 23 MB vs 17 MB here, because Loyalsoldier
      # post-processes (adds private/ads/ir/ru categories, rewrites cn). So
      # using them would silently change your routing rules. This package
      # ships the exact bytes v2rayN's own updater would download.
      #
      # PROVENANCE
      #
      # v2rayN's geo updater is literally this repo (Global.cs:8):
      #   GeoUrl = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/{0}.dat"
      # so "latest release of this repo" == "what the GUI button fetches".
      # Verified by comparing category sets: your home geosite.dat and the
      # release zip's are the same lineage, differing only in freshness.
      #
      # HASHES
      #
      # Taken from the GitHub release asset `digest` field (sha256), which is
      # what the API reports, then converted with `nix hash convert --to sri`.
      # Cross-checkable against the repo's own *.sha256sum assets.
      #
      # NOT INCLUDED, deliberately: geoip.metadb, Country.mmdb and
      # geoip-only-cn-private.dat. v2rayN fetches those from three *different*
      # URLs (Global.cs:653-655 - Loyalsoldier/geoip release branch and
      # MetaCubeX/meta-rules-dat), so pretending to own them here would be a
      # lie. They stay as shipped in the v2rayN zip and keep updating via the
      # GUI.
      # ──────────────────────────────────────────────────────────────
      v2ray-rules-dat = prev.stdenv.mkDerivation rec {
        pname = "v2ray-rules-dat";
        # release tag is a UTC timestamp; matches what `latest` resolves to
        version = "202609052329";

        srcGeoip = prev.fetchurl {
          url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${version}/geoip.dat";
          hash = "sha256-QUnmB1MPkdppe61GlvjFnwpHWvOOaUBeQSRDjJiGxyE=";
        };

        srcGeosite = prev.fetchurl {
          url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${version}/geosite.dat";
          hash = "sha256-b7FDV1IObZ6Lo+V1Xdq63W6QLHp9nyHl/la5QUgC43A=";
        };

        # both files are already final artefacts
        dontConfigure = true;
        dontBuild = true;
        dontFixup = true;
        phases = [ "installPhase" ];

        installPhase = ''
          runHook preInstall

          # share/v2ray/ mirrors nixpkgs' own v2ray-geoip layout, so the
          # files are where anyone expecting nixpkgs' geodata would look.
          mkdir -p $out/share/v2ray $out/bin
          install -m644 ${srcGeoip}   $out/share/v2ray/geoip.dat
          install -m644 ${srcGeosite} $out/share/v2ray/geosite.dat

          # v2rayN expects geodata at the ROOT of its bin/ dir, because
          # XRAY_LOCATION_ASSET is set to GetBinPath("") - i.e. bin/, not
          # bin/xray/. Exposed under bin/ too so the v2rayn assembly can
          # copy from one path without knowing the internals.
          ln -s share/v2ray/geoip.dat   $out/bin/geoip.dat
          ln -s share/v2ray/geosite.dat $out/bin/geosite.dat

          runHook postInstall
        '';

        passthru.updateScript = prev.nix-update-script {
          extraArgs = [
            "--version-prefix-regex=^"
            "--url" "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/@version@/geoip.dat"
          ];
        };

        meta = with prev.lib; {
          description = "Prebuilt geoip.dat / geosite.dat for Xray and sing-box";
          homepage = "https://github.com/Loyalsoldier/v2ray-rules-dat";
          # repo is MIT; the data aggregates lists with mixed licensing
          license = licenses.mit;
          sourceProvenance = with sourceTypes; [ binaryNativeCode ];
          platforms = platforms.all;
        };
      };
    })
  ];
  environment.systemPackages = [ v2ray-rules-dat ];
}