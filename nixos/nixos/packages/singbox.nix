{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # ──────────────────────────────────────────────────────────────
      # sing-box (prebuilt, STATIC musl build)
      #
      # Two deliberate choices here, both learned the hard way:
      #
      # 1. THE MUSL BUILD, NOT THE DEFAULT ONE.
      #    sing-box publishes two linux-amd64 tarballs. The plain one is
      #    dynamically linked (PT_INTERP = /lib64/ld-linux-x86-64.so.2,
      #    rewritten by autoPatchelfHook to a store glibc). The -musl one
      #    has NO interpreter at all - verified with an ELF program-header
      #    scan. That matters because v2rayN copies its cores out of the
      #    read-only store into ~/.local/share/v2rayN/bin, and a copy that
      #    points at a store glibc is outside Nix's reachability graph: once
      #    that glibc is garbage-collected the binary fails to exec with
      #    ENOENT and v2rayN reports "ErrorStartingProcess ... No such file
      #    or directory" for a file that plainly exists. That is exactly what
      #    silently killed sing-box on this machine while xray/mihomo (both
      #    static) kept working. Static = immune.
      #
      #    Cost: the static build does not ship libcronet.so, so sing-box's
      #    `browser` outbound (Chrome QUIC parroting) cannot dlopen it. v2rayN
      #    does not generate that outbound, so nothing is lost here.
      #
      # 2. PINNED TO 1.13.x ON PURPOSE - DO NOT BUMP TO 1.14.
      #    v2rayN 7.24.9 generates DNS rules that sing-box 1.14 rejects:
      #      FATAL initialize dns router: validate dns rule[0]: Response Match
      #      Fields (ip_cidr, ...) require match_response to be enabled
      #    Verified by running `sing-box check` against this machine's real
      #    TUN config (binConfigs/configPre.json): 1.13.19 passes, 1.13.21
      #    passes, 1.14.0 hard-fails. 1.14 also removed the legacy DNS server
      #    format v2rayN still emits. So 1.13.21 is the newest core v2rayN can
      #    actually drive; upgrading past it needs a v2rayN that emits the new
      #    schema first.
      # ──────────────────────────────────────────────────────────────
      sing-box = prev.stdenv.mkDerivation rec {
        pname = "sing-box-bin";
        version = "1.13.21";

        src = prev.fetchurl {
          url = "https://github.com/SagerNet/sing-box/releases/download/v${version}/sing-box-${version}-linux-amd64-musl.tar.gz";
          hash = "sha256-iGSrs7cqa0BERajCUYPHnPpEqA3vDXdax5V450+5gOc=";
        };

        nativeBuildInputs = [ prev.gnutar prev.xz ];

        # tarball wraps everything in sing-box-1.13.21-linux-amd64-musl/
        sourceRoot = "sing-box-${version}-linux-amd64-musl";

        # nothing to build, and the binary must not be stripped or patched:
        # it is already static and self-contained
        dontConfigure = true;
        dontBuild = true;
        dontFixup = true;

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          install -Dm755 sing-box $out/bin/sing-box
          runHook postInstall
        '';

        passthru.updateScript = prev.nix-update-script { };

        meta = with prev.lib; {
          description = "Universal proxy platform (prebuilt static musl binary)";
          homepage = "https://github.com/SagerNet/sing-box";
          license = licenses.gpl3Only;
          sourceProvenance = with sourceTypes; [ binaryNativeCode ];
          platforms = [ "x86_64-linux" ];
          mainProgram = "sing-box";
        };
      };
    })
  ];
  environment.systemPackages = [ sing-box ];
}