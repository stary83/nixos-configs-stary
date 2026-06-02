{ pkgs, ... }:

let
  version = "7.22.3";
  v2rayn-unwrapped = pkgs.stdenv.mkDerivation {
    pname = "v2rayn-unwrapped";
    inherit version;
    src = pkgs.fetchurl {
      url = "https://github.com/2dust/v2rayN/releases/download/${version}/v2rayN-linux-64.zip";
      hash = "sha256-QFyL+kR3S50rj77I3CY/xNLDqe82lptcSHOiqO5JRcc=";
    };
    nativeBuildInputs = [ pkgs.unzip ];
    sourceRoot = "v2rayN-linux-64";
    installPhase = ''
      runHook preInstall
      mkdir -p $out/opt/v2rayn
      cp -r . $out/opt/v2rayn/
      chmod +x $out/opt/v2rayn/v2rayN
      runHook postInstall
    '';
  };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      v2rayn = final.buildFHSEnv {
        name = "v2rayn-${version}";

        # Run the real binary directly – no need for a `cd` prefix
        runScript = "${v2rayn-unwrapped}/opt/v2rayn/v2rayN";

        targetPkgs = (ps: with ps; [
          bash
          coreutils
          which
          iproute2
          iptables
          polkit
          sudo
          xorg.libX11
          xorg.libXrandr
          xorg.libXi
          libGL
          libxkbcommon
          fontconfig
          icu
          zlib
          openssl
          lttng-ust_2_12
          krb5
          stdenv.cc.cc.lib
        ]);
      };
    })
  ];

  environment.systemPackages = with pkgs; [ v2rayn ];
  boot.kernelModules = [ "tun" ];
}
