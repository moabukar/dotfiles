#!/bin/bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/util.sh

check_macos

print_info "Configuring macOS Dock..."

# Remove all current dock items
print_info "Clearing current Dock..."
dockutil --remove all --no-restart

# Add apps to dock (customize this list based on the right image)
print_info "Adding apps to Dock..."

# Core macOS apps
dockutil --add "/System/Applications/Launchpad.app" --no-restart
dockutil --add "/Applications/Discord.app" --no-restart 2>/dev/null || true
dockutil --add "/Applications/Google Chrome.app" --no-restart 2>/dev/null || true
dockutil --add "/Applications/Notion.app" --no-restart 2>/dev/null || true
dockutil --add "/System/Applications/System Settings.app" --no-restart
dockutil --add "/Applications/WhatsApp.app" --no-restart 2>/dev/null || true
dockutil --add "/System/Applications/Messages.app" --no-restart
dockutil --add "/Applications/Microsoft Teams.app" --no-restart 2>/dev/null || true
dockutil --add "/Applications/zoom.us.app" --no-restart 2>/dev/null || true

# Development apps
dockutil --add "/Applications/OrbStack.app" --no-restart 2>/dev/null || true
dockutil --add "/Applications/Visual Studio Code.app" --no-restart 2>/dev/null || true
dockutil --add "/Applications/Cursor.app" --no-restart 2>/dev/null || true
dockutil --add "/Applications/iTerm.app" --no-restart 2>/dev/null || true

# Add folders (Downloads, Applications)
dockutil --add "~/Downloads" --view grid --display folder --no-restart 2>/dev/null || true

# Restart Dock to apply changes
killall Dock

print_success "Dock configured!"
print_info "You can customize apps in scripts/dock.sh"
