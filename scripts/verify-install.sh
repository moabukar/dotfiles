#!/usr/bin/env bash
# Verification script for installed packages

set -e

# Ensure Homebrew is in PATH
eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"

echo "Checking installed packages..."
FAILED=0

# Check each package individually
if command -v git > /dev/null 2>&1; then
  echo "✓ git: $(which git)"
else
  echo "✗ git: NOT FOUND"
  FAILED=1
fi

if command -v kubectl > /dev/null 2>&1; then
  echo "✓ kubectl: $(which kubectl)"
else
  echo "✗ kubectl: NOT FOUND"
  FAILED=1
fi

# Check for tofu (OpenTofu) instead of terraform
if command -v tofu > /dev/null 2>&1; then
  echo "✓ tofu: $(which tofu)"
elif command -v terraform > /dev/null 2>&1; then
  echo "✓ terraform: $(which terraform)"
else
  echo "✗ terraform/tofu: NOT FOUND"
  FAILED=1
fi

if command -v helm > /dev/null 2>&1; then
  echo "✓ helm: $(which helm)"
else
  echo "✗ helm: NOT FOUND"
  FAILED=1
fi

if command -v node > /dev/null 2>&1; then
  echo "✓ node: $(which node)"
else
  echo "✗ node: NOT FOUND"
  FAILED=1
fi

if command -v python3 > /dev/null 2>&1; then
  echo "✓ python3: $(which python3)"
else
  echo "✗ python3: NOT FOUND"
  FAILED=1
fi

# Docker is optional (not available on macOS runners by default)
if command -v docker > /dev/null 2>&1; then
  echo "✓ docker: $(which docker)"
else
  echo "⚠ docker: NOT FOUND (optional, skipping)"
fi

if [ $FAILED -eq 1 ]; then
  echo ""
  echo "Some packages failed to install!"
  exit 1
fi

echo ""
echo "All core packages verified!"
