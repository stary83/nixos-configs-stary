{ config, pkgs, lib, ... }:

let
  version = "2.23.12";

  # Inner derivation: unpack and patch the Arch package
  windscribe-unwrapped = pkgs.stdenv.mkDerivation rec {
    pname = "windscribe-unwrapped";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/Windscribe/Desktop-App/releases/download/v${version}/windscribe_${version}_amd64.pkg.tar.zst";
      hash = "sha256-PLLhsWcdROz/VOCj1g8bSITFHWQ54TNbNi6Dw3m5M58=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.zstd ];
    buildInputs = with pkgs; [
      qt6.qtbase
      qt6.qtnetworkauth
      qt6.qtwebsockets
      qt6.qttools
      qt6.qtwayland
      qt6.qtsvg
      openssl
      openvpn
      wireguard-tools
      stoken
      libcap
      polkit
      systemd
      libnotify
      libappindicator
      gtk3
      libsodium
      curl
      zlib
      libx11
      libGL
      libxkbcommon
      libcap_ng
      libnl
      acl
    ];

    # Do not wrap Qt – the FHS wrapper will provide the proper environment
    dontWrapQtApps = true;
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/opt/windscribe
      cp -r opt/windscribe/* $out/opt/windscribe/

      mkdir -p $out/bin
      ln -s $out/opt/windscribe/Windscribe $out/bin/windscribe
      ln -s $out/opt/windscribe/windscribe-cli $out/bin/windscribe-cli

      # Desktop file and icons (optional)
      mkdir -p $out/share/applications $out/share/icons/hicolor
      cp -r usr/share/applications/*.desktop $out/share/applications/ 2>/dev/null || true
      cp -r usr/share/icons/hicolor/* $out/share/icons/hicolor/ 2>/dev/null || true

      runHook postInstall
    '';

    autoPatchelfLibs = [ "$out/opt/windscribe/lib" ];

    meta = with lib; {
      description = "Windscribe VPN client (unwrapped)";
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  };

  # Outer derivation: FHS environment that makes the binary feel at home
  windscribe = pkgs.buildFHSEnv {
    name = "windscribe";
    runScript = "${windscribe-unwrapped}/bin/windscribe";

    targetPkgs = pkgs: with pkgs; [
      # Base system libraries
      glibc
      zlib
      openssl
      systemd
      # Qt and graphics
      qt6.qtbase
      qt6.qtwayland
      libxkbcommon
      libGL
      libx11
      # Audio
      libpulseaudio
      # Networking
      libcap
      openvpn
      wireguard-tools
      # Fonts / ICU
      fontconfig
      freetype
      icu
      # Required by the helper / internal binaries
      libcap_ng
      libnl
      acl
      polkit
    ];

    # Make the CLI accessible as well
    runScriptPhase = ''
      mkdir -p $out/bin
      ln -sf $runScript $out/bin/windscribe
      ln -sf ${windscribe-unwrapped}/bin/windscribe-cli $out/bin/windscribe-cli
    '';
  };

in {
  environment.systemPackages = [ windscribe ];
}