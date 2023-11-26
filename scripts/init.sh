#!/bin/bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/util.sh

check_macos

# Set bash
# chsh -s /bin/bash

# Install xcode
if ! xcode-select -p 1>/dev/null; then
	print_info "Installing Xcode Command Line Tools..."
  xcode-select --install
fi

# Install bre
if ! command -v brew >/dev/null; then
	print_info "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null
fi

print_info ""
print_info "#####################################################"
print_info "Finished initial setup."
print_info "#####################################################"
print_info ""