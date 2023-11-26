#!/bin/bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/util.sh

function set_homebrew() {
	check_macos
	check_command "brew"

	print_info "homebrew doctor..."
	brew doctor

	print_info "homebrew update..."
	brew update

	print_info "homebrew upgrade..."
	brew upgrade

	print_info "Installing Homebrew packages..."
	current_dir=$(dirname "${BASH_SOURCE[0]:-$0}")
	brew bundle --file "$current_dir/.Brewfile"
}

set_homebrew