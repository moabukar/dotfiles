#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]:-$0}")/util.sh"

check_macos

# ====================
#
# Base
#
# ====================

# Disable auto-capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# ====================
#
# Dock
#
# ====================

# Set Dock size to small
defaults write com.apple.dock tilesize -int 36

# Disable animation at application launch
defaults write com.apple.dock launchanim -bool false

# Keep Dock visible (don't auto-hide)
defaults write com.apple.dock autohide -bool false

# Show indicators for open applications
defaults write com.apple.dock show-process-indicators -bool true

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Minimize windows using genie effect
defaults write com.apple.dock mineffect -string "genie"

# ====================
#
# Finder
#
# ====================

# Disable animation
defaults write com.apple.finder DisableAllAnimations -bool true

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show files with all extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Display the status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Display the path bar
defaults write com.apple.finder ShowPathbar -bool true

# ====================
#
# SystemUIServer
#
# ====================

# Display date, day, and time in the menu bar
defaults write com.apple.menuextra.clock DateFormat -string 'EEE d MMM HH:mm'

# Display battery level in the menu bar
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# ====================
#
# Trackpad
#
# ====================

# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Secondary click: bottom right corner
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Disable natural scrolling (traditional scroll direction)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Trackpad speed (0-3, higher is faster)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5

# ====================
#
# Mouse
#
# ====================

# Disable natural scrolling for mouse too
defaults write -g com.apple.swipescrolldirection -bool false

# Mouse speed (0-3, higher is faster)
defaults write NSGlobalDomain com.apple.mouse.scaling -float 2.5

# Enable secondary click (right-click) for mouse
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton"

# ====================
#
# Security — Application Firewall (needs sudo; bootstrap runs in a real terminal)
#
# ====================

if command -v sudo >/dev/null 2>&1; then
	sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on >/dev/null 2>&1 || true
	sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on >/dev/null 2>&1 || true
	sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned on --setallowsignedapp on >/dev/null 2>&1 || true
fi

# ====================
#
# Rectangle (window management) — custom half/center shortcuts
#   left half  = Cmd+Shift+L   (keyCode 37)
#   right half = Cmd+Shift+R   (keyCode 15)
#   center     = Cmd+Shift+Return (keyCode 36)
#   modifierFlags 1179648 = Cmd+Shift
#
# ====================

defaults write com.knollsoft.Rectangle leftHalf  -dict keyCode -int 37 modifierFlags -int 1179648
defaults write com.knollsoft.Rectangle rightHalf -dict keyCode -int 15 modifierFlags -int 1179648
defaults write com.knollsoft.Rectangle center    -dict keyCode -int 36 modifierFlags -int 1179648

for app in "Dock" \
	"Finder" \
	"SystemUIServer" \
	"Rectangle"; do
	killall "${app}" &> /dev/null
done
# Relaunch Rectangle so the new shortcuts take effect
open -a Rectangle &> /dev/null || true

print_info ""
print_info "#####################################################"
print_info "Finished defaults setup."
print_info "#####################################################"
print_info ""
