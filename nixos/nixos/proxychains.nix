{ config, pkgs, lib, ... }:

{
  environment.etc."proxychains.conf" = {
    text = ''
      # proxychains.conf - Choose your proxy by uncommenting ONE line below
      #
      # Dynamic chain - tries each proxy in order until one works
      dynamic_chain
      # Resolve DNS through proxy (prevents leaks)
      proxy_dns
      # Quiet mode (less logging)
      quiet_mode
      
      [ProxyList]
      
      # === SOCKS5 Proxy (MasterDnsVPN on port 18000) ===
      # Uncomment the next line to use SOCKS5:
      socks5 127.0.0.1 18000
      
      # === HTTP Proxy (if you have one on port 18001) ===
      # Uncomment the next line INSTEAD to use HTTP:
      # http 127.0.0.1 18001
    '';
    mode = "0644";
  };
  # proxychains4 is the command to be used 
  # Make sure proxychains-ng is installed
  environment.systemPackages = [ pkgs.proxychains-ng ];
}
