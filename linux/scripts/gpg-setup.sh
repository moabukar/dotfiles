#!/bin/bash

# GPG Setup for Signed Git Commits (Linux)

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

info "Setting up GPG for signed Git commits"

# Check if GPG is installed
if ! command -v gpg &> /dev/null; then
    error "GPG not found. Install it first: sudo apt install gnupg"
    exit 1
fi

# List existing keys
info "Checking for existing GPG keys..."
if gpg --list-secret-keys --keyid-format=long | grep -q "sec"; then
    info "Existing GPG keys found:"
    gpg --list-secret-keys --keyid-format=long
    echo ""
    read -p "Do you want to use an existing key? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter the key ID (long format): " key_id
    else
        key_id=""
    fi
else
    info "No existing GPG keys found"
    key_id=""
fi

# Generate new key if needed
if [ -z "$key_id" ]; then
    info "Generating new GPG key..."
    echo ""
    echo "Please enter your details:"
    read -p "Name: " name
    read -p "Email: " email

    info "Generating key with RSA 4096..."
    gpg --batch --generate-key <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $name
Name-Email: $email
Expire-Date: 0
%no-protection
%commit
EOF

    # Get the new key ID
    key_id=$(gpg --list-secret-keys --keyid-format=long | grep "sec" | tail -1 | sed 's/.*rsa4096\///' | awk '{print $1}')
    success "GPG key generated: $key_id"
fi

# Configure Git
info "Configuring Git to use GPG key..."
git config --global user.signingkey "$key_id"
git config --global commit.gpgsign true
git config --global tag.gpgsign true

# Export public key
info "Exporting public key..."
gpg --armor --export "$key_id" > ~/gpg-public-key.asc
success "Public key exported to ~/gpg-public-key.asc"

# Copy to clipboard if xclip exists
if command -v xclip &> /dev/null; then
    gpg --armor --export "$key_id" | xclip -selection clipboard
    success "Public key copied to clipboard!"
fi

echo ""
info "Next steps:"
echo "1. Add your GPG key to GitHub: https://github.com/settings/keys"
echo "2. Click 'New GPG key' and paste the key"
echo ""
echo "To export your key again later:"
echo "  gpg --armor --export $key_id"
echo ""
echo "To list your keys:"
echo "  gpg --list-secret-keys --keyid-format=long"
