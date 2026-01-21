#!/bin/bash

# GPG Setup for Signed Git Commits

source "$(dirname "${BASH_SOURCE[0]:-$0}")/util.sh"

print_notice "Setting up GPG for signed Git commits"

# Check if GPG is installed
if ! command -v gpg &> /dev/null; then
    error "GPG not found. Install it first: brew install gnupg"
    exit 1
fi

# List existing keys
print_info "Checking for existing GPG keys..."
if gpg --list-secret-keys --keyid-format=long | grep -q "sec"; then
    print_info "Existing GPG keys found:"
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
    print_info "No existing GPG keys found"
    key_id=""
fi

# Generate new key if needed
if [ -z "$key_id" ]; then
    print_info "Generating new GPG key..."
    echo ""
    echo "Please enter your details:"
    read -p "Name: " name
    read -p "Email: " email

    print_info "Generating key with RSA 4096..."
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
print_info "Configuring Git to use GPG key..."
git config --global user.signingkey "$key_id"
git config --global commit.gpgsign true
git config --global tag.gpgsign true

# Export public key
print_info "Exporting public key..."
gpg --armor --export "$key_id" > ~/gpg-public-key.asc
echo ""
print_success "Public key exported to ~/gpg-public-key.asc"

# Copy to clipboard if pbcopy exists
if command -v pbcopy &> /dev/null; then
    gpg --armor --export "$key_id" | pbcopy
    print_success "Public key copied to clipboard!"
fi

echo ""
print_notice "Next steps:"
echo "1. Add your GPG key to GitHub: https://github.com/settings/keys"
echo "2. Click 'New GPG key' and paste the key"
echo ""
echo "To export your key again later:"
echo "  gpg --armor --export $key_id"
echo ""
echo "To list your keys:"
echo "  gpg --list-secret-keys --keyid-format=long"
