{ pkgs, ... }:

{
  services.haproxy = {
    enable = true;
    config = ''
    global
        daemon
        maxconn 4096

    defaults
        mode tcp
        log global
        option tcplog
        timeout connect 50s
        timeout client 50s
        timeout server 50s

    # Single listen block for your aggregator
    listen socks-aggregator
        bind *:19000             # The port Nekoray will connect to
        mode tcp
        balance roundrobin      # Distributes connections equally to all proxies

        # === IMPORTANT: REPLACE THESE WITH YOUR OWN PROXY SERVERS ===
        # The 'check' parameter enables HAProxy's health checks.
        server masterdns18000 127.0.0.1:18000 check
        server masterdns17999 127.0.0.1:17999 check
        server masterdns17998 127.0.0.1:17998 check
	server masterdns17997 127.0.0.1:17997 check
	server masterdns17996 127.0.0.1:17996 check
	server masterdns17995 127.0.0.1:17995 check
	server masterdns17994 127.0.0.1:17994 check
  '';
  };
}
