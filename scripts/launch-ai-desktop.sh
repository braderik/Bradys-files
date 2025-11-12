#!/usr/bin/env bash
#
# launch-ai-desktop.sh
# Opens ChatGPT and Claude web interfaces in your default browser
# Designed for macOS host computer accessed via Chrome Remote Desktop
#
# Usage:
#   chmod +x launch-ai-desktop.sh
#   ./launch-ai-desktop.sh
#
# Or add to Login Items for automatic launch when CRD connects

set -euo pipefail

echo "🚀 Launching AI Desktop Interfaces..."

# Detect default browser or use Chrome as fallback
if [[ -d "/Applications/Google Chrome.app" ]]; then
    BROWSER="Google Chrome"
elif [[ -d "/Applications/Safari.app" ]]; then
    BROWSER="Safari"
elif [[ -d "/Applications/Microsoft Edge.app" ]]; then
    BROWSER="Microsoft Edge"
else
    echo "❌ No supported browser found. Please install Chrome, Safari, or Edge."
    exit 1
fi

echo "📱 Using browser: $BROWSER"

# Open both AI interfaces
open -a "$BROWSER" "https://chat.openai.com/"
sleep 1
open -a "$BROWSER" "https://claude.ai/"

echo "✅ Launched ChatGPT and Claude interfaces"
echo "💡 Tip: Pin these tabs in your browser for quick access"
