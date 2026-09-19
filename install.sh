#!/bin/bash
# ==============================================================================
# One-line installer for Happ Kill Switch & Identity Shield
# Usage: curl -fsSL https://raw.githubusercontent.com/USER/happ-killswitch/main/install.sh | sudo bash
# ==============================================================================
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "[!] Please run this installer as root (e.g. sudo bash install.sh)" >&2
    exit 1
fi

REPO_URL="https://raw.githubusercontent.com/sunatillo-muratov/happ-killswitch/main"
TMP_DIR=$(mktemp -d)

echo "[*] Downloading Happ Kill Switch..."
if [ -f "$(dirname "$0")/happ-killswitch" ]; then
    # Local installation
    cp "$(dirname "$0")/happ-killswitch" /usr/local/bin/happ-killswitch
else
    # Remote installation
    curl -fsSL "${REPO_URL}/happ-killswitch" -o /usr/local/bin/happ-killswitch
fi

chmod 755 /usr/local/bin/happ-killswitch
/usr/local/bin/happ-killswitch install

rm -rf "$TMP_DIR"
echo "[✓] Installation complete! Try running: sudo happ-killswitch on"
