{ pkgs, lib, ... }:

let
  vpnProxyToggle = pkgs.writeShellScriptBin "proxy-nix-toggle" ''
    #!/bin/bash
    
    # Configuration
    SOCKS5_PORT="18000"  # Your MasterDnsVPN SOCKS5 port
    HTTP_PROXY_PORT="8123"
    PRIVOXY_CONFIG="/tmp/privoxy.conf"
    PRIVOXY_PIDFILE="/tmp/privoxy.pid"
    
    case "$1" in
      on)
        echo "→ Starting Privoxy HTTP proxy bridge..."
        
        # Create privoxy config
        cat > $PRIVOXY_CONFIG << EOF
        listen-address 127.0.0.1:$HTTP_PROXY_PORT
        forward-socks5t / 127.0.0.1:$SOCKS5_PORT .
	ssl-cert-verify off
        enable-remote-toggle 0
        enable-edit-actions 0
        buffer-limit 4096
        logfile /dev/null
        jarfile /dev/null
        EOF
        
        # Start privoxy (must be in PATH)
        if ! command -v privoxy &> /dev/null; then
          echo "⚠ Warning: privoxy not found. Install with: nix-shell -p privoxy"
          ${pkgs.privoxy}/bin/privoxy --no-daemon $PRIVOXY_CONFIG &
        else
          privoxy --no-daemon $PRIVOXY_CONFIG &
        fi
        echo $! > $PRIVOXY_PIDFILE
        sleep 1
        
        echo "→ Configuring nix-daemon to use HTTP proxy..."
        sudo mkdir -p /run/systemd/system/nix-daemon.service.d/
        sudo tee /run/systemd/system/nix-daemon.service.d/override.conf > /dev/null << EOF
[Service]
Environment="http_proxy=http://127.0.0.1:$HTTP_PROXY_PORT"
Environment="https_proxy=http://127.0.0.1:$HTTP_PROXY_PORT"
Environment="all_proxy=http://127.0.0.1:$HTTP_PROXY_PORT"
Environment="no_proxy=localhost,127.0.0.1"
EOF
        
        sudo systemctl daemon-reload
        sudo systemctl restart nix-daemon
        
        echo "✓ VPN proxy ENABLED"
        echo "  → HTTP proxy: 127.0.0.1:$HTTP_PROXY_PORT"
        echo "  → SOCKS5 target: 127.0.0.1:$SOCKS5_PORT"
        ;;
        
      off)
        echo "→ Stopping Privoxy..."
        if [ -f $PRIVOXY_PIDFILE ]; then
          kill $(cat $PRIVOXY_PIDFILE) 2>/dev/null
          rm -f $PRIVOXY_PIDFILE
        fi
        killall privoxy 2>/dev/null
        
        echo "→ Removing nix-daemon proxy configuration..."
        sudo rm -f /run/systemd/system/nix-daemon.service.d/override.conf
        sudo systemctl daemon-reload
        sudo systemctl restart nix-daemon
        
        # Clean up iptables if any were left (from previous attempts)
        sudo iptables -t nat -D OUTPUT -p tcp -j REDSOCKS 2>/dev/null
        sudo iptables -t nat -F REDSOCKS 2>/dev/null
        sudo iptables -t nat -X REDSOCKS 2>/dev/null
        
        echo "✓ VPN proxy DISABLED"
        ;;
        
      status)
        if [ -f /run/systemd/system/nix-daemon.service.d/override.conf ]; then
          echo "✓ VPN proxy is ENABLED"
          echo "  → HTTP proxy running on port $HTTP_PROXY_PORT"
          if [ -f $PRIVOXY_PIDFILE ]; then
            echo "  → Privoxy PID: $(cat $PRIVOXY_PIDFILE)"
          fi
        else
          echo "✗ VPN proxy is DISABLED"
        fi
        ;;
        
      *)
        echo "MasterDnsVPN Proxy Control"
        echo ""
        echo "Usage: vpn-proxy-toggle {on|off|status}"
        echo ""
        echo "Commands:"
        echo "  on     - Enable proxy for all nix commands"
        echo "  off    - Disable proxy and restore direct connection"
        echo "  status - Show current proxy state"
        echo ""
        echo "Before using 'on', ensure MasterDnsVPN is running on port $SOCKS5_PORT"
        ;;
    esac
  '';
  
in {
  # Make the script available system-wide
  environment.systemPackages = [ vpnProxyToggle pkgs.privoxy ];
  
  # Ensure privoxy is available (comment out if you prefer nix-shell)
  
  # Optional: Add convenience aliases to shell
  programs.bash.shellAliases = {
    proxy-nix-on = "proxy-nix-toggle on";
    proxy-nix-off = "proxy-nix-toggle off";
    proxy-nix-status = "proxy-nix-toggle status";
  };
}
