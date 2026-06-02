{ pkgs, ... }:

{
  services.privoxy = {
    enable = true;
    settings = {
      # Listen for HTTP connections on port 8123
      listen-address = "127.0.0.1:18002";

      # Forward all traffic to your SOCKS5 proxy (MasterDnsVPN)
      forward-socks5t = "/ 127.0.0.1:19000 .";

      # Optional: quiet down logging
      debug = 0;
    };
  };
}
