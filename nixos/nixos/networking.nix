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
    packages/senpai-scanner.nix
    # packages/vaydns.nix 
    # packages/windscribe.nix
    # packages/onionhop.nix
    # packages/dns-hop.nix
    # packages/aether.nix
    
    # ------ v2rayn & cores, v2rayn needs the cores to be imported ---
    packages/v2rayn.nix
    packages/mihomo.nix
    packages/singbox.nix
    packages/xray.nix
    # ----------------------------------------------------------------

    # ----------------------------------------------------------------
  ];

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    libreswan
    strongswan
    linux-wifi-hotspot # the cli for this provides the create_ap command
    haveged # wifi hotspot says this is needed
    openvpn
    sstp
    wireguard-tools
    libproxy
    tproxy
    # nebula
    
    # cloudflare-warp
    # proton-vpn
    # amneziawg-go
    # amnezia-vpn
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

    # amnezia-vpn.enable = true;
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
  

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };


  networking = {
    hostName = "StarConst"; # Define your hostname.
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      allowedTCPPortRanges = [
        # { 
          # from = 18000;
	        # to = 18010;
	      # }
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
