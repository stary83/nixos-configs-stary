{ inputs, pkgs, ... }:
let
  unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
in {
  imports = [
    ./proxychains.nix
    ./privoxy.nix
    ./certificates.nix
    # --------------------- nixpkgs overlays -------------------------
    packages/masterDnsVpn.nix
    packages/stormdnsclient.nix
    packages/xray.nix
    packages/sni-spoofing-go.nix
    packages/zerodpi.nix
    # packages/psiphon.nix
    packages/senpai-scanner.nix
    # packages/windscribe.nix
    packages/onionhop.nix
    packages/v2rayn.nix
    # ----------------------------------------------------------------
  ];

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    libreswan
    strongswan
    xl2tpd
    linux-wifi-hotspot # the cli for this provides the create_ap command
    haveged # wifi hotspot says this is needed
    openvpn
    # smartdns
    sstp
    wireguard-tools
    libproxy
    # temp-latest-stable.xray
    xray-core # xrays latest version packaged by me
    sing-box
    unstable.v2ray
    # unstable.v2rayn
    v2rayn # currently using my own overlay with the latest version
    tproxy
    masterDnsVpn
    stormdns
    # nebula
    sni-spoofing-go
    # cloudflare-warp
    proton-vpn
    amneziawg-go
    amnezia-vpn
  ];

  programs = { 
    nm-applet = {
      enable = true;
    };
    throne = {
      enable = true;
      tunMode.enable = true;
      tunMode.setuid = true;
    };
    amnezia-vpn.enable = true;
  };
  services = {
    strongswan = {
      enable = true;
    };
  };

  environment.etc."ipsec.secrets".text = ''
    include ipsec.d/ipsec.nm-l2tp.secrets
  '';

  environment.etc."strongswan.conf".text = "";
  

  networking = {
    hostName = "StarConst"; # Define your hostname.
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
      allowedTCPPortRanges = [
        { 
          from = 18000;
	  to = 18010;
	}
        {
          from = 19000;
	  to = 19010;
	}
      ];
      allowedUDPPortRanges = [];

    };

    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-l2tp
        networkmanager-ssh
        networkmanager-sstp
        networkmanager-iodine
        networkmanager-openvpn
        networkmanager-openconnect
        networkmanager-strongswan
      ];
    };

    timeServers = [ "pool.ntp.org" "time.google.com" "time.windows.com" ];

  };

}
