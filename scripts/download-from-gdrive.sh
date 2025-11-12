#!/usr/bin/env bash
#
# download-from-gdrive.sh
# Download files from Google Drive using file ID or share link
#
# Usage:
#   ./download-from-gdrive.sh FILE_ID
#   ./download-from-gdrive.sh "https://drive.google.com/file/d/FILE_ID/view"
#
# Example:
#   ./download-from-gdrive.sh 1A2B3C4D5E6F7G8H
#   ./download-from-gdrive.sh "https://drive.google.com/file/d/1A2B3C4D5E6F7G8H/view"

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo "Usage: $0 FILE_ID or SHARE_LINK"
    echo ""
    echo "Examples:"
    echo "  $0 1A2B3C4D5E6F7G8H"
    echo "  $0 'https://drive.google.com/file/d/1A2B3C4D5E6F7G8H/view'"
    echo ""
    echo "To get the File ID from a share link:"
    echo "  https://drive.google.com/file/d/FILE_ID_HERE/view"
    echo "                                  ^^^^^^^^^^^^"
}

print_error() {
    echo -e "${RED}✗${NC} $1" >&2
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Extract file ID from various Google Drive URL formats
extract_file_id() {
    local input="$1"

    # If it's already just an ID (no slashes), return as-is
    if [[ ! "$input" =~ / ]]; then
        echo "$input"
        return
    fi

    # Extract from various URL formats
    # https://drive.google.com/file/d/FILE_ID/view
    # https://drive.google.com/open?id=FILE_ID
    # https://drive.google.com/uc?id=FILE_ID

    if [[ "$input" =~ /d/([a-zA-Z0-9_-]+) ]]; then
        echo "${BASH_REMATCH[1]}"
    elif [[ "$input" =~ id=([a-zA-Z0-9_-]+) ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        print_error "Could not extract file ID from: $input"
        exit 1
    fi
}

# Download file from Google Drive
download_file() {
    local file_id="$1"
    local output_file="${2:-chrome-remote-desktop-setup.zip}"

    print_info "Downloading from Google Drive..."
    print_info "File ID: $file_id"

    # Create temp directory for cookies
    local cookie_file=$(mktemp)

    # First request to get confirmation token for large files
    print_info "Fetching file metadata..."
    local confirm_url="https://drive.google.com/uc?export=download&id=${file_id}"
    local confirm_page=$(curl -sc "$cookie_file" "$confirm_url" 2>/dev/null)

    # Extract confirmation token if present (for large files)
    local confirm_token=""
    if echo "$confirm_page" | grep -q "confirm="; then
        confirm_token=$(echo "$confirm_page" | grep -o 'confirm=[^&]*' | sed 's/confirm=//' | head -n 1)
        print_info "Large file detected, using confirmation token"
    fi

    # Download the actual file
    print_info "Downloading file..."

    if [[ -n "$confirm_token" ]]; then
        # Large file with confirmation
        curl -Lb "$cookie_file" \
             "https://drive.google.com/uc?export=download&confirm=${confirm_token}&id=${file_id}" \
             -o "$output_file" \
             --progress-bar
    else
        # Small file or direct download
        curl -Lb "$cookie_file" \
             "https://drive.google.com/uc?export=download&id=${file_id}" \
             -o "$output_file" \
             --progress-bar
    fi

    # Cleanup
    rm -f "$cookie_file"

    # Verify download
    if [[ -f "$output_file" ]]; then
        local file_size=$(du -h "$output_file" | cut -f1)
        print_success "Downloaded successfully: $output_file ($file_size)"
        return 0
    else
        print_error "Download failed"
        return 1
    fi
}

# Main script
main() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}  Google Drive Downloader for Mac${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""

    # Check arguments
    if [[ $# -eq 0 ]]; then
        print_error "No file ID or link provided"
        echo ""
        print_usage
        exit 1
    fi

    local input="$1"
    local output_file="${2:-chrome-remote-desktop-setup.zip}"

    # Extract file ID
    print_info "Processing input: $input"
    local file_id=$(extract_file_id "$input")

    if [[ -z "$file_id" ]]; then
        print_error "Could not extract file ID"
        exit 1
    fi

    print_success "File ID: $file_id"

    # Check if output file already exists
    if [[ -f "$output_file" ]]; then
        print_warning "File already exists: $output_file"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Download cancelled"
            exit 0
        fi
        rm -f "$output_file"
    fi

    # Download
    if download_file "$file_id" "$output_file"; then
        echo ""
        print_success "Download complete!"
        echo ""
        print_info "Next steps:"
        echo "  1. Extract the ZIP file:"
        echo "     unzip $output_file"
        echo ""
        echo "  2. Navigate to the extracted folder:"
        echo "     cd Bradys-files-*"
        echo ""
        echo "  3. Run the setup:"
        echo "     ./scripts/setup-mac-host.sh"
        echo ""
    else
        echo ""
        print_error "Download failed!"
        echo ""
        print_info "Troubleshooting:"
        echo "  • Check that the file ID is correct"
        echo "  • Ensure the file is shared (Anyone with the link can view)"
        echo "  • Try downloading via browser: https://drive.google.com/file/d/${file_id}/view"
        echo ""
        exit 1
    fi
}

# Run main function
main "$@"
