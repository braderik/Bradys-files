#!/usr/bin/env bash
#
# setup-mac-host.sh
# Configure macOS for Chrome Remote Desktop hosting
# Sets up power management, Login Items, and validates prerequisites
#
# Usage:
#   chmod +x setup-mac-host.sh
#   ./setup-mac-host.sh

set -euo pipefail

echo "🔧 Chrome Remote Desktop Mac Host Setup"
echo "========================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if Chrome is installed
echo "1️⃣ Checking prerequisites..."
if [[ ! -d "/Applications/Google Chrome.app" ]]; then
    print_error "Google Chrome not found"
    echo "   Please install Chrome from: https://www.google.com/chrome/"
    exit 1
fi
print_status "Google Chrome installed"

# Check Chrome Remote Desktop
CRD_HELPER="/Library/PrivilegedHelperTools/com.google.chromeremotedesktop.me2me.sh"
if [[ ! -f "$CRD_HELPER" ]]; then
    print_warning "Chrome Remote Desktop not detected"
    echo "   Install from: https://remotedesktop.google.com/access"
    echo "   1. Click 'Set up Remote Access'"
    echo "   2. Download and install the Chrome Remote Desktop extension"
    echo "   3. Follow the on-screen setup wizard"
    echo ""
    read -p "Press Enter after installing Chrome Remote Desktop..."
fi

# Configure power management to prevent sleep
echo ""
echo "2️⃣ Configuring power management..."

# Prevent system sleep while plugged in (display can sleep)
sudo pmset -c sleep 0 2>/dev/null && print_status "Disabled system sleep on AC power" || print_warning "Could not modify power settings (requires sudo)"
sudo pmset -c displaysleep 10 2>/dev/null && print_status "Display sleep: 10 minutes on AC power" || true

echo ""
echo "3️⃣ Setting up auto-launch script..."

# Get the directory where this script lives
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LAUNCH_SCRIPT="$SCRIPT_DIR/launch-ai-desktop.sh"

# Make launch script executable
if [[ -f "$LAUNCH_SCRIPT" ]]; then
    chmod +x "$LAUNCH_SCRIPT"
    print_status "Made launch-ai-desktop.sh executable"

    # Create LaunchAgent for auto-start
    PLIST_PATH="$HOME/Library/LaunchAgents/com.user.ai-desktop-launcher.plist"
    mkdir -p "$HOME/Library/LaunchAgents"

    cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.ai-desktop-launcher</string>
    <key>ProgramArguments</key>
    <array>
        <string>$LAUNCH_SCRIPT</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
EOF

    # Load the LaunchAgent
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    launchctl load "$PLIST_PATH" 2>/dev/null && print_status "Configured auto-launch at login" || print_warning "Could not load LaunchAgent"
else
    print_error "launch-ai-desktop.sh not found at $LAUNCH_SCRIPT"
fi

echo ""
echo "4️⃣ Security checklist..."
echo "   Please verify manually:"
echo "   □ Google Account has 2-Step Verification enabled"
echo "   □ Chrome Remote Desktop PIN is set (6+ digits)"
echo "   □ Backup codes saved securely"
echo ""

echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Go to https://remotedesktop.google.com/access on this Mac"
echo "   2. Set up Remote Access if not already done"
echo "   3. Name your Mac (e.g., 'Home-Mac-AI')"
echo "   4. Set a secure PIN (6+ digits)"
echo "   5. Test connection from your Windows PC"
echo ""
echo "🔗 Windows PC: Navigate to https://remotedesktop.google.com/access"
echo "   Sign in with the same Google account and select your Mac"
echo ""
