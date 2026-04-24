{ pkgs, ... }: 
{
  
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    libreswan
    strongswan
    xl2tpd
    linux-wifi-hotspot
    haveged # wifi hotspot says this is needed
    openvpn
    # smartdns
    sstp
    wireguard-tools
    libproxy
    xray
    v2raya
    # nebula
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
    proxychains = {
      

    };
  };
  services = {
    strongswan = {
      enable = true;
    };
    v2raya = {
      enable = true;
    }; 
  };

  environment.etc."ipsec.secrets".text = ''
    include ipsec.d/ipsec.nm-l2tp.secrets
  '';

  environment.etc."strongswan.conf".text = "";

  networking = {
    hostName = "StarConst"; # Define your hostname.
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
