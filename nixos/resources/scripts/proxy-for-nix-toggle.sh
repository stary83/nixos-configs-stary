#!/bin/bash
if [ -f /run/systemd/system/nix-daemon.service.d/override.conf ]; then
  sudo rm /run/systemd/system/nix-daemon.service.d/override.conf
  sudo systemctl daemon-reload && sudo systemctl restart nix-daemon
  echo "✓ Proxy OFF"
else
  sudo mkdir -p /run/systemd/system/nix-daemon.service.d/
  sudo tee /run/systemd/system/nix-daemon.service.d/override.conf > /dev/null << 'EOF'
[Service]
Environment="http_proxy=socks5h://127.0.0.1:18000"
Environment="https_proxy=socks5h://127.0.0.1:18000"
Environment="all_proxy=socks5h://127.0.0.1:18000"
EOF
  sudo systemctl daemon-reload && sudo systemctl restart nix-daemon
  echo "✓ Proxy ON"
fi
