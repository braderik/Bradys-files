#!/usr/bin/env bash
#
# Chrome Remote Desktop Installer for Mac
# Downloads and sets up ChatGPT/Claude remote access tools
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/install.sh | bash
#
# Or download and run manually:
#   curl -O https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/install.sh
#   chmod +x install.sh
#   ./install.sh

set -euo pipefail

# Configuration
BRANCH="claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu"
REPO_URL="https://github.com/braderik/Bradys-files"
INSTALL_DIR="$HOME/chrome-remote-desktop-setup"
TEMP_DIR=$(mktemp -d)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}${BOLD}========================================${NC}"
    echo -e "${BLUE}${BOLD}  Chrome Remote Desktop Setup for Mac${NC}"
    echo -e "${BLUE}${BOLD}  ChatGPT + Claude Access${NC}"
    echo -e "${BLUE}${BOLD}========================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

cleanup() {
    rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

# Main installation
main() {
    print_header

    # Check if running on macOS
    if [[ "$(uname)" != "Darwin" ]]; then
        print_error "This script is designed for macOS only."
        print_info "Detected OS: $(uname)"
        exit 1
    fi
    print_success "Running on macOS"

    # Check for required tools
    echo ""
    echo "Checking prerequisites..."

    if ! command -v curl &> /dev/null; then
        print_error "curl is not installed. Please install curl first."
        exit 1
    fi
    print_success "curl found"

    if ! command -v unzip &> /dev/null; then
        print_error "unzip is not installed. Please install unzip first."
        exit 1
    fi
    print_success "unzip found"

    # Download repository
    echo ""
    echo "Downloading files from GitHub..."
    print_info "Repository: $REPO_URL"
    print_info "Branch: $BRANCH"

    ZIP_URL="$REPO_URL/archive/refs/heads/$BRANCH.zip"
    ZIP_FILE="$TEMP_DIR/repo.zip"

    if curl -fsSL -o "$ZIP_FILE" "$ZIP_URL"; then
        print_success "Downloaded repository"
    else
        print_error "Failed to download repository"
        print_info "URL: $ZIP_URL"
        exit 1
    fi

    # Extract files
    echo ""
    echo "Extracting files..."

    if unzip -q "$ZIP_FILE" -d "$TEMP_DIR"; then
        print_success "Extracted files"
    else
        print_error "Failed to extract files"
        exit 1
    fi

    # Find the extracted directory (GitHub adds branch name to folder)
    EXTRACTED_DIR=$(find "$TEMP_DIR" -maxdepth 1 -type d -name "Bradys-files-*" | head -n 1)

    if [[ -z "$EXTRACTED_DIR" ]]; then
        print_error "Could not find extracted directory"
        exit 1
    fi

    # Create installation directory
    echo ""
    echo "Installing to: $INSTALL_DIR"

    if [[ -d "$INSTALL_DIR" ]]; then
        print_warning "Installation directory already exists"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
        rm -rf "$INSTALL_DIR"
    fi

    mkdir -p "$INSTALL_DIR"

    # Copy files
    if cp -R "$EXTRACTED_DIR"/* "$INSTALL_DIR/"; then
        print_success "Files installed"
    else
        print_error "Failed to copy files"
        exit 1
    fi

    # Make scripts executable
    echo ""
    echo "Setting up scripts..."

    chmod +x "$INSTALL_DIR/scripts/launch-ai-desktop.sh"
    chmod +x "$INSTALL_DIR/scripts/setup-mac-host.sh"
    chmod +x "$INSTALL_DIR/install.sh"
    print_success "Scripts are now executable"

    # Installation complete
    echo ""
    print_success "Installation complete!"
    echo ""
    echo -e "${BOLD}📁 Files installed to:${NC} $INSTALL_DIR"
    echo ""
    echo -e "${BOLD}📋 What's included:${NC}"
    echo "  • scripts/setup-mac-host.sh       - Automated Mac configuration"
    echo "  • scripts/launch-ai-desktop.sh    - Auto-launch ChatGPT & Claude"
    echo "  • docs/remote-ui-sop.md           - Complete setup guide"
    echo "  • docs/security-checklist.md      - Security hardening"
    echo "  • docs/test-plan-remote-ui.md     - Testing checklist"
    echo "  • README-REMOTE-DESKTOP.md        - Quick start guide"
    echo ""
    echo -e "${BOLD}🚀 Next steps:${NC}"
    echo ""
    echo "1. Run the setup script:"
    echo -e "   ${GREEN}cd $INSTALL_DIR${NC}"
    echo -e "   ${GREEN}./scripts/setup-mac-host.sh${NC}"
    echo ""
    echo "2. Enable Google 2-Step Verification:"
    echo "   https://myaccount.google.com/signinoptions/two-step-verification"
    echo ""
    echo "3. Set up Chrome Remote Desktop:"
    echo "   https://remotedesktop.google.com/access"
    echo ""
    echo "4. Read the documentation:"
    echo -e "   ${GREEN}open $INSTALL_DIR/README-REMOTE-DESKTOP.md${NC}"
    echo ""

    # Ask if user wants to run setup now
    read -p "Do you want to run the setup script now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "Running setup script..."
        cd "$INSTALL_DIR"
        ./scripts/setup-mac-host.sh
    else
        print_info "You can run the setup later with: cd $INSTALL_DIR && ./scripts/setup-mac-host.sh"
    fi

    echo ""
    echo -e "${GREEN}${BOLD}✅ All done! Happy remote working!${NC}"
    echo ""
}

# Run main function
main "$@"
