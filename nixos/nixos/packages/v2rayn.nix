{ pkgs, ... }:

let
  version = "7.24.9";

  # Prebuilt binary, not nixpkgs' `v2rayn`: that builds from source, and the
  # source repo ships no cores at all, so it can never find one.
  #
  # Cores come from our own packages (xray.nix / singbox.nix / mihomo.nix),
  # all statically linked on purpose - see singbox.nix for why a dynamic core
  # silently rots here. Geodata is NOT packaged; v2rayN's in-app geo updater
  # owns those files.
in
{
  nixpkgs.overlays = [
    (final: prev:
    let
      # X11 libs moved from the `xorg` scope to top-level between 24.11 and
      # 26.05. Resolve whichever spelling this nixpkgs has.
      x11Libs =
        if prev ? libX11 then
          with prev; [ libX11 libXrandr libXi libXcursor libXext libICE libSM ]
        else
          with prev.xorg; [ libX11 libXrandr libXi libXcursor libXext libICE libSM ];

      # Single source of truth for what nix owns under bin/. Drives both the
      # installPhase copy and the refresh manifest so they cannot drift.
      # `dir`/`exe` are fixed by v2rayN (CoreInfoManager.GetCoreExecFile ->
      # Utils.GetBinPath), not ours to choose. `final.` so overlay ordering
      # across packages/ is irrelevant.
      coreFiles = [
        { dir = "xray";     exe = "xray";     src = final.xray-core; }
        { dir = "sing_box"; exe = "sing-box"; src = final.sing-box;  }
        { dir = "mihomo";   exe = "mihomo";   src = final.mihomo;    }
      ];

      managedFiles = map (c: "${c.dir}/${c.exe}") coreFiles;

      # v2rayN copies bin/ into ~/.local/share/v2rayN/bin only when a file is
      # MISSING (CoreManager.Init, overwrite=false), and runs it from there -
      # so that copy is a snapshot of whichever $out first ran and never
      # follows upgrades. Verified: after bumping sing-box to 1.13.21 the
      # store had 1.13.21 while the running home copy was still 1.13.19.
      #
      # Re-sync unconditionally on every launch. A stamp/"did $out change"
      # check was removed: it saved 0.09s (measured, 157MB page-cached) and
      # had two failure modes - it could not repair a core clobbered while
      # $out was unchanged, and it wrote the stamp even when install failed,
      # recording a false success that was never retried.
      # Everything not in managedFiles (geodata, user downloads, cache.db) is
      # left alone. Best-effort: must never block launch, so exits 0 always.
      refreshCores = final.writeShellScript "v2rayn-refresh-cores" ''
        store_bin="$1"
        data="''${XDG_DATA_HOME:-$HOME/.local/share}"
        home_bin="$data/v2rayN/bin"
        lock="$data/v2rayN/.refresh.lock"

        # First run: leave it to v2rayN's own seeding.
        [ -d "$home_bin" ] || exit 0
        [ -d "$store_bin" ] || exit 0

        # A concurrent instance is already refreshing.
        if ! mkdir "$lock" 2>/dev/null; then exit 0; fi
        trap 'rmdir "$lock" 2>/dev/null' EXIT

        # install(1) unlinks first, so it replaces the read-only (-r-xr-xr-x)
        # seeded copies that plain cp fails on. Never delete.
        files="
        ${prev.lib.concatStringsSep "\n        " managedFiles}
        "

        for f in $files; do
          [ -f "$store_bin/$f" ] || continue
          install -Dm755 "$store_bin/$f" "$home_bin/$f" 2>/dev/null || true
        done

        exit 0
      '';
    in
    {
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

        # x11Libs is appended because it is itself a list; buildInputs is flat.
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

        sourceRoot = "v2rayN-linux-64";

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/v2rayN $out/bin
          cp -r . $out/share/v2rayN/
          chmod +x $out/share/v2rayN/v2rayN

          # Replace the zip's frozen cores with our tracked ones. Store mounts
          # 0555, so chmod explicitly - the seeded home copy must land
          # executable. Geodata at the bin/ root stays as shipped.
          ${prev.lib.concatStringsSep "\n          " (map (c: ''
            rm -rf $out/share/v2rayN/bin/${c.dir}
            mkdir -p $out/share/v2rayN/bin/${c.dir}
            cp ${c.src}/bin/${c.exe} $out/share/v2rayN/bin/${c.dir}/${c.exe}
            chmod 755 $out/share/v2rayN/bin/${c.dir}/${c.exe}
          '') coreFiles)}

          # AmazTool is the self-updater. It resolves via GetBaseDirectory()
          # (the store) and gets chmod'd every launch -> EROFS on every start.
          # Removing it makes UpgradeAppExists() false, so the code takes the
          # `continue` branch. Self-update is wrong on NixOS regardless.
          rm -f $out/share/v2rayN/AmazTool

          # Upstream's own opt-out marker: HasWritePermission() -> false, so
          # config goes to ~/.local/share/v2rayN instead of the store.
          touch $out/share/v2rayN/NotStoreConfigHere.txt

          install -Dm644 $out/share/v2rayN/v2rayN.png \
            $out/share/icons/hicolor/256x256/apps/v2rayn.png

          # V2RAYN_LOCAL_APPLICATION_DATA_V2=1 makes StartupPath() return
          # ~/.local/share/v2rayN; without it GetCoreExecFile() looks inside
          # the read-only store and you get "Corefile not found". That seed is
          # one-way, hence refreshCores.
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

  # ── TUN: system side (the package alone cannot do this) ──────────────

  # v2rayN execs /bin/bash by absolute path for every sudo step, and
  # run_as_sudo.sh is written with a "#!/bin/bash" shebang started with
  # UseShellExecute=false - the kernel parses that shebang, so NixOS (which
  # ships only /bin/sh) gets ENOENT. Mirrors nixpkgs' own binsh activation.
  system.activationScripts.binbash = pkgs.lib.stringAfter [ "binsh" ] ''
    mkdir -p /bin
    ln -sfn ${pkgs.bash}/bin/bash /bin/.bash.tmp
    mv /bin/.bash.tmp /bin/bash
  '';

  boot.kernelModules = [ "tun" ];

  # The sudo step is `exec sudo -S` inside run_as_sudo.sh, so `sudo` must be on
  # the GUI session PATH. NixOS ships the setuid wrapper at
  # /run/current-system/sw/bin/sudo, which is there by default. Do NOT add
  # pkgs.sudo to systemPackages - that risks shadowing setuid with non-setuid.

  # TUN installs a default route, so replies return on a different interface
  # than they left by; strict reverse-path filtering drops exactly that.
  networking.firewall.checkReversePath = "loose";

  # ── Updating ─────────────────────────────────────────────────────────
  # Cores: bump version + hash in packages/xray.nix, singbox.nix, mihomo.nix,
  # rebuild, then launch v2rayN - refreshCores re-seeds every launch, so there
  # is no stamp, no version variable, and nothing to remember.
  #
  # v2rayN's own updater (Options -> Check update):
  #   CORES: OFF. It fetches from GitHub and overwrites nix-managed binaries.
  #     For sing-box it is actively dangerous: it fetches 1.14.x, which
  #     REJECTS the config v2rayN generates (verified - `sing-box check` on
  #     binConfigs/configPre.json fails on 1.14.0, passes on 1.13.19/1.13.21).
  #     That presents as "TUN broke" when it is a config-schema mismatch.
  #   GEO FILES: ON - the sole owner now, and it works (writable home dir).
  #
  # TUN address vs docker: v2rayN defaults sing-box to 172.18.0.1/30
  # (Global.cs TunIPv4Address[0]) and the docker bridge holds 172.18.0.1/16.
  # v2rayN also adds a `reject` rule for its own address, so the collision
  # blackholes traffic rather than merely being ambiguous. Set IPv4Address in
  # the TUN GUI settings (e.g. 10.77.0.1/30) - it lives in sqlite, not nix.
  #
  # If your server address is a hostname and connections hang once TUN owns
  # 0.0.0.0/0: the lookup for it enters the tunnel. sing-box's strict_route
  # usually installs `not from all iif lo` to sidestep this for a local
  # resolver; otherwise add a highest-priority `direct` rule for that IP.
}