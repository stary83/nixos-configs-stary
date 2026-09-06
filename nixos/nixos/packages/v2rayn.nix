{ pkgs, ... }:

let
  version = "7.24.9";

  # ──────────────────────────────────────────────────────────────────
  # The proxy cores v2rayN will actually run.
  #
  # The release zip bundles xray 26.7.28 + sing-box 1.13.19 + mihomo
  # 1.19.29, frozen whenever 2dust last built the package. We throw those
  # three away and substitute our own packages, so core updates are driven
  # by this repo (bump a version, rebuild) instead of by v2rayN's "check
  # update" button - which is the right division of labour on NixOS, where
  # nix owns /bin and the store is read-only.
  #
  # Geodata: geoip.dat + geosite.dat come from our own v2ray-rules-dat
  # package (see packages/v2ray-rules-dat.nix), which is byte-identical to
  # what v2rayN's "update geo data" button downloads (Global.cs:8 points at
  # the same Loyalsoldier releases). So the GUI updater and nix agree.
  #
  # pkgs.v2ray-rules-dat does NOT exist in nixpkgs (verified: `p ?
  # v2ray-rules-dat` -> false on 26.05), which is why we carry it. nixpkgs
  # has the upstream *source* repos instead (v2ray-geoip,
  # v2ray-domain-list-community) but those compile to different bytes.
  #
  # Still from the zip, deliberately: geoip.metadb, Country.mmdb,
  # geoip-only-cn-private.dat and the compiled srss/ rule-sets. v2rayN
  # fetches those from three other URLs we do not track, so the GUI updater
  # remains the right owner for them.
  #
  # All three substitutes are STATICALLY linked (no PT_INTERP), which is not
  # incidental - see sing-box-bin.nix. v2rayN copies cores out of the store
  # into ~/.local/share/v2rayN/bin, and a dynamic copy whose interpreter is
  # a store glibc can be garbage-collected out from under it. That is exactly
  # how sing-box silently died on this machine while xray kept working.
  # ──────────────────────────────────────────────────────────────────
  coresVersion = "${pkgs.xray-core.version}-${pkgs.sing-box.version}-${pkgs.mihomo.version}-${pkgs.v2ray-rules-dat.version}";

in
{
  nixpkgs.overlays = [
    (final: prev:
    let
      # The X11 libs moved from the `xorg` scope to top-level between 24.11
      # and 26.05 (where the old xorg.* names still work but emit deprecation
      # warnings). Resolve whichever spelling this nixpkgs actually has, so
      # the file evaluates cleanly from either the channel or the flake pin.
      x11Libs =
        if prev ? libX11 then
          with prev; [ libX11 libXrandr libXi libXcursor libXext libICE libSM ]
        else
          with prev.xorg; [ libX11 libXrandr libXi libXcursor libXext libICE libSM ];

      # ── the ONE list that defines what nix owns inside bin/ ─────────
      # Used both to build the store tree and to generate the refresh
      # manifest, so the two can never disagree. Anything not listed here
      # (geoip.metadb, Country.mmdb, geoip-only-cn-private.dat, srss/) is
      # left entirely to v2rayN's own updater - we ship it once from the
      # zip but do not track it, because v2rayN fetches those from three
      # other URLs (Global.cs:653-655) we would be lying about owning.
      managedFiles = [
        "xray/xray"
        "sing_box/sing-box"
        "mihomo/mihomo"
        "geoip.dat"
        "geosite.dat"
      ];

      # Assemble the drop-in replacement for the zip's bin/ core dirs.
      # `final.` (not `prev.`) so overlay ordering across your packages/
      # files does not matter - final is the fixpoint of all overlays.
      v2rayn-cores = final.stdenv.mkDerivation {
        pname = "v2rayn-cores";
        version = coresVersion;

        # pure assembly, no source
        phases = [ "installPhase" ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin/xray $out/bin/sing_box $out/bin/mihomo

          # cp then chmod: the store mounts everything 0555 and we want the
          # self-seeded home copy to land executable
          cp ${final.xray-core}/bin/xray        $out/bin/xray/xray
          cp ${final.sing-box-bin}/bin/sing-box $out/bin/sing_box/sing-box
          cp ${final.mihomo-bin}/bin/mihomo     $out/bin/mihomo/mihomo

          # geodata sits at the bin/ ROOT, not inside bin/xray/, because
          # XRAY_LOCATION_ASSET is set to GetBinPath("") - i.e. bin/ itself
          cp ${final.v2ray-rules-dat}/share/v2ray/geoip.dat   $out/bin/geoip.dat
          cp ${final.v2ray-rules-dat}/share/v2ray/geosite.dat $out/bin/geosite.dat

          chmod 755 $out/bin/xray/xray $out/bin/sing_box/sing-box $out/bin/mihomo/mihomo
          chmod 644 $out/bin/geoip.dat $out/bin/geosite.dat

          runHook postInstall
        '';

        meta = with prev.lib; {
          description = "Proxy cores + geodata for v2rayN (xray + sing-box + mihomo + rules-dat)";
          homepage = "https://github.com/2dust/v2rayN";
          license = with licenses; [ mpl20 gpl3Only gpl3Only mit ];
          platforms = [ "x86_64-linux" ];
          sourceProvenance = with sourceTypes; [ binaryNativeCode ];
        };
      };

      # v2rayN seeds ~/.local/share/v2rayN/bin from the package's bin/ only
      # when that directory is *missing* (CoreManager.Init uses
      # overwrite=false). The copy is therefore a snapshot of whichever
      # package output first ran and never follows upgrades.
      #
      # Re-sync the nix-managed files whenever $out changes. Best-effort by
      # design: it must never stop v2rayN from launching, so every path
      # exits 0.
      #
      # The list is generated from `managedFiles` rather than discovered
      # with `find`, because the files live at two different depths
      # (bin/xray/xray and bin/geoip.dat) and a depth-based heuristic is how
      # geodata silently stopped being refreshed. One source of truth.
      refreshCores = final.writeShellScript "v2rayn-refresh-cores" ''
        store_bin="$1"
        data="''${XDG_DATA_HOME:-$HOME/.local/share}"
        home_bin="$data/v2rayN/bin"
        stamp="$home_bin/.nix-package-out"
        lock="$data/v2rayN/.refresh.lock"

        # First run: leave it to v2rayN's own seeding.
        [ -d "$home_bin" ] || exit 0
        [ -d "$store_bin" ] || exit 0

        # Fast path: already up to date with this $out.
        [ -f "$stamp" ] && [ "$(cat "$stamp" 2>/dev/null)" = "$store_bin" ] && exit 0

        # Don't fight a concurrent instance; it is refreshing right now.
        if ! mkdir "$lock" 2>/dev/null; then exit 0; fi
        trap 'rmdir "$lock" 2>/dev/null' EXIT

        # nix-managed files, generated from managedFiles in the .nix source.
        # Anything NOT here (geoip.metadb, Country.mmdb, srss/, the user's
        # own downloaded cores) is left untouched.
        files="
        ${prev.lib.concatStringsSep "\n        " managedFiles}
        "

        # install(1) unlinks the destination first, so it replaces the
        # read-only (-r-xr-xr-x) seeded copies that a plain cp would fail on.
        # Never delete: the home dir also holds the user's own downloads and
        # cache.db.
        for f in $files; do
          [ -f "$store_bin/$f" ] || continue
          install -Dm755 "$store_bin/$f" "$home_bin/$f" 2>/dev/null || true
        done

        printf '%s' "$store_bin" > "$stamp" 2>/dev/null
        exit 0
      '';
    in
    {
      inherit v2rayn-cores;

      # ──────────────────────────────────────────────────────────────
      # v2rayN (prebuilt Linux binary, with our own cores)
      #
      # Why the prebuilt zip and not upstream nixpkgs' `v2rayn`:
      #   nixpkgs builds it with buildDotnetModule from *source*, and the
      #   source repo ships NO cores (no bin/xray, no geodata - verified
      #   against the 7.24.9 tag). So the official package can never find
      #   a core and TUN is unreachable. The release zip is self-contained.
      #
      # TUN notes - all three matter, see the system config below:
      #   1. v2rayN hardcodes Global.LinuxBash = "/bin/bash" (Global.cs:95)
      #      and TUN always runs the core through sudo (CoreManager.cs
      #      ShouldRunAsSudo -> CoreAdminManager.RunProcessAsLinuxSudo).
      #      NixOS has no /bin/bash, only /bin/sh. -> activation script.
      #   2. The store is read-only, so config/logs/bin cannot live next to
      #      the exe. We force the data dir into XDG via the env var AND the
      #      upstream NotStoreConfigHere.txt marker.
      #   3. Do NOT wrap this in buildFHSEnv: chrootenv runs in a user
      #      namespace with a single mapped UID, so sudo's setuid bit is
      #      inert and TUN can never start. (This is why 7.22.3 failed.)
      # ──────────────────────────────────────────────────────────────
      v2rayn = prev.stdenv.mkDerivation rec {
        pname = "v2rayN";
        inherit version;

        src = prev.fetchurl {
          url = "https://github.com/2dust/v2rayN/releases/download/${version}/v2rayN-linux-64.zip";
          hash = "sha256-iEf3f8H36Pmv7QeQcHMm7GaF98PxC2PdekN3L0v+X+8=";
        };

        nativeBuildInputs = with prev; [
          unzip
          makeWrapper
          autoPatchelfHook
          copyDesktopItems
        ];

        # x11Libs is appended rather than listed because it is itself a list
        # and buildInputs must be flat.
        buildInputs = (with prev; [
          stdenv.cc.cc.lib
          glib
          gtk3
          libGL
          fontconfig
          icu
          openssl
          libpulseaudio
          dbus
          libsecret
        ]) ++ x11Libs;

        # the zip wraps everything in v2rayN-linux-64/
        sourceRoot = "v2rayN-linux-64";

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/v2rayN $out/bin
          cp -r . $out/share/v2rayN/

          # the store is mounted read-only with 0555 files; keep these
          # executable so the self-seeded home copy stays runnable
          chmod +x $out/share/v2rayN/v2rayN

          # ── swap the frozen bundled cores for our tracked ones ──────
          # v2rayN locates cores via CoreInfoManager.GetCoreExecFile ->
          # Utils.GetBinPath(exe, coreType), i.e. bin/<dir>/<exe> with these
          # exact directory names (verified against the 7.24.9 zip layout:
          # bin/{xray,sing_box,mihomo,srss}). srss is compiled geodata, not
          # a core, so it stays as shipped.
          rm -rf $out/share/v2rayN/bin/xray \
                 $out/share/v2rayN/bin/sing_box \
                 $out/share/v2rayN/bin/mihomo

          mkdir -p $out/share/v2rayN/bin
          cp -r ${v2rayn-cores}/bin/xray \
                ${v2rayn-cores}/bin/sing_box \
                ${v2rayn-cores}/bin/mihomo \
                $out/share/v2rayN/bin/

          # geodata at the bin/ ROOT: overwrite the zip's frozen copies with
          # the tracked ones. Depth matters here - these are NOT inside a
          # core subdir, because XRAY_LOCATION_ASSET points at bin/ itself.
          cp ${v2rayn-cores}/bin/geoip.dat   $out/share/v2rayN/bin/geoip.dat
          cp ${v2rayn-cores}/bin/geosite.dat $out/share/v2rayN/bin/geosite.dat

          # AmazTool is v2rayN's self-updater. CoreManager.Init resolves it
          # via GetBaseDirectory() (the *store* path) and calls chmod on it,
          # which throws EROFS on every single launch - and self-updating is
          # wrong on NixOS regardless, since nix owns these files. Removing
          # it makes UpgradeAppExists() return false, so the code takes the
          # `continue` branch: no error, and "check update" says the updater
          # is unavailable instead of silently corrupting anything.
          rm -f $out/share/v2rayN/AmazTool

          # upstream's own opt-out marker (package-osx.sh uses it too):
          # HasWritePermission() returns false -> config goes to
          # ~/.local/share/v2rayN instead of the store
          touch $out/share/v2rayN/NotStoreConfigHere.txt

          install -Dm644 $out/share/v2rayN/v2rayN.png \
            $out/share/icons/hicolor/256x256/apps/v2rayn.png

          # V2RAYN_LOCAL_APPLICATION_DATA_V2=1 makes StartupPath() return
          # ~/.local/share/v2rayN, which is what lets CoreManager.Init
          # copy bin/ (cores + geodata) out of the store on first launch.
          # Without it GetCoreExecFile() looks inside the read-only store
          # and you get "Corefile not found".
          #
          # But that seed is one-way (overwrite=false), so the home-dir cores
          # go stale on every upgrade -- including when the store paths they
          # were patchelf'd against are garbage-collected out from under them.
          # refreshCores re-syncs them whenever $out changes.
          makeWrapper $out/share/v2rayN/v2rayN $out/bin/v2rayN \
            --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath buildInputs}" \
            --set V2RAYN_LOCAL_APPLICATION_DATA_V2 1 \
            --run "${refreshCores} $out/share/v2rayN/bin"

          runHook postInstall
        '';

        desktopItems = [
          (prev.makeDesktopItem {
            name = "v2rayn";
            exec = "v2rayN";
            icon = "v2rayn";
            desktopName = "v2rayN";
            genericName = "Proxy Client";
            comment = "Powerful GUI client for Xray / sing-box / mihomo";
            categories = [ "Network" "Utility" ];
            terminal = false;
            startupWMClass = "v2rayN";
          })
        ];

        passthru = {
          inherit v2rayn-cores;
          updateScript = prev.nix-update-script { };
        };

        meta = with prev.lib; {
          description = "v2rayN - Powerful GUI client for Xray / sing-box / mihomo";
          homepage = "https://github.com/2dust/v2rayN";
          license = licenses.gpl3Plus;
          platforms = [ "x86_64-linux" ];
          mainProgram = "v2rayN";
        };
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    v2rayn
  ];

  # ──────────────────────────────────────────────────────────────────
  # TUN support (system side - the package alone cannot do this)
  # ──────────────────────────────────────────────────────────────────

  # v2rayN execs /bin/bash by absolute path for every sudo step
  # (run_as_sudo.sh is written with a "#!/bin/bash" shebang and started
  # via ProcessStartInfo with UseShellExecute=false, so the kernel parses
  # that shebang -> ENOENT on NixOS). Mirror what nixpkgs' own
  # environment.binsh activation script does for /bin/sh.
  # Upstream's own debian packaging declares `bash (>= 5.2.21)` as a hard
  # runtime dependency, so this is a genuine requirement, not a quirk.
  system.activationScripts.binbash = pkgs.lib.stringAfter [ "binsh" ] ''
    mkdir -p /bin
    ln -sfn ${pkgs.bash}/bin/bash /bin/.bash.tmp
    mv /bin/.bash.tmp /bin/bash
  '';

  # TUN devices need the tun module.
  boot.kernelModules = [ "tun" ];

  # v2rayN's sudo step is `exec sudo -S -- env ...` inside run_as_sudo.sh,
  # so `sudo` must resolve on the PATH of the *GUI session* (not the login
  # shell). NixOS ships the setuid wrapper at /run/current-system/sw/bin/sudo,
  # which is on the session PATH by default - so nothing is required here.
  # Do NOT add pkgs.sudo to systemPackages to "fix" it; that risks shadowing
  # the setuid wrapper with a non-setuid binary. Check with:
  #   sudo -n true 2>&1 | grep -qi password && echo 'sudo ok'

  # xray/sing-box install a default route via the tunnel, so replies come
  # back on a different interface than they went out on. The default strict
  # reverse-path filter drops exactly that traffic.
  # Upstream's own package-debian.sh declares MIN_KERNEL="6.12" for TUN.
  # This host runs 7.0.10, so it's satisfied; kept as a comment rather than
  # an assert so the module stays copy-pasteable.
  networking.firewall.checkReversePath = "loose";

  # ──────────────────────────────────────────────────────────────────
  # Updating cores now
  #
  #   xray     -> packages/xray.nix            (26.7.28)
  #   sing-box -> packages/sing-box-bin.nix    (1.13.21, CAPPED - see notes)
  #   mihomo   -> packages/mihomo-bin.nix      (1.19.30)
  #   geodata  -> packages/v2ray-rules-dat.nix (202609052329)
  #
  # Bump version + hash there, rebuild, and the next v2rayN launch re-seeds
  # ~/.local/share/v2rayN/bin automatically (refreshCores). No manual
  # `rm -rf` needed any more.
  #
  # Or bump them all at once with:
  #   nix run nixpkgs#nix-update -- v2rayn-cores --flake
  # (each of the four carries passthru.updateScript except xray.nix, which
  # predates that convention - bump that one by hand.)
  #
  # ── v2rayN's own updater: what to leave on and off ─────────────────
  # Options -> Check update:
  #   CORES: uncheck. A GUI core download overwrites a nix-managed binary
  #     with an upstream one. For sing-box that is actively dangerous - the
  #     updater will happily fetch 1.14.x, which REJECTS the config v2rayN
  #     generates (verified: `sing-box check` on your real binConfigs/
  #     configPre.json fails on 1.14.0 with "dns rule[0]: Response Match
  #     Fields ... require match_response to be enabled", and passes on
  #     1.13.19/1.13.21). That is the trap: click "update core", get a
  #     core that cannot read your config, and it looks like TUN broke.
  #   GEO FILES: safe to leave checked. v2rayN's GeoUrl (Global.cs:8) is
  #     Loyalsoldier/v2ray-rules-dat releases/latest - the same bytes this
  #     package pins. A GUI update just moves you ahead of nix, and the next
  #     rebuild moves you back. No corruption, no stale-interpreter risk.
  #   geoip.metadb / Country.mmdb: leave checked; we do not track those.
  #
  # ── TUN address vs docker ───────────────────────────────────────────
  # v2rayN defaults sing-box to 172.18.0.1/30 (Global.cs:748, first entry of
  # TunIPv4Address). Your docker bridge br-a13506f887eb holds 172.18.0.1/16,
  # so the two collide whenever a container network is up. v2rayN also adds
  # a `reject` rule for its own address, so the collision is self-inflicted
  # traffic blackholing, not just a routing ambiguity.
  # Fix in the GUI (TunModeItem.IPv4Address -> SingboxInboundService.cs:72),
  # e.g. 10.77.0.1/30. Not settable from nix: it lives in the sqlite config,
  # and there is no env var for it.
  #
  # NOTE (not expressible in nix): once TUN grabs 0.0.0.0/0, the DNS lookup
  # for *your own server's hostname* also goes into the tunnel -> deadlock on
  # connect. sing-box's strict_route usually installs a `not from all iif lo`
  # rule that sidesteps this for a local resolver; if your server address is
  # a hostname and connections hang, add a highest-priority routing rule
  # sending that IP/CIDR to `direct`, or set Bind Interface to your NIC.
  # ──────────────────────────────────────────────────────────────────
}