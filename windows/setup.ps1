# Windows DevOps Environment Setup
# Run as Administrator

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

Write-Host "=" -ForegroundColor Cyan -NoNewline
Write-Host " Windows DevOps Environment Setup " -ForegroundColor White -NoNewline
Write-Host "=" -ForegroundColor Cyan
Write-Host ""

# Check Windows version
$version = [System.Environment]::OSVersion.Version
if ($version.Major -lt 10 -or ($version.Major -eq 10 -and $version.Build -lt 19041)) {
    Write-Host "Error: Windows 10 version 2004 or higher is required for WSL2" -ForegroundColor Red
    exit 1
}

# Install WSL2
Write-Host "Installing WSL2..." -ForegroundColor Blue
if (!(Get-Command wsl -ErrorAction SilentlyContinue)) {
    wsl --install --no-launch
    Write-Host "WSL2 installed. Please restart your computer and run this script again." -ForegroundColor Yellow
    exit 0
}

# Check if WSL2 is the default version
$wslVersion = wsl --status | Select-String "Default Version: 2"
if (!$wslVersion) {
    Write-Host "Setting WSL2 as default..." -ForegroundColor Blue
    wsl --set-default-version 2
}

# Install Ubuntu if not already installed
$ubuntuInstalled = wsl --list --quiet | Select-String "Ubuntu"
if (!$ubuntuInstalled) {
    Write-Host "Installing Ubuntu 22.04..." -ForegroundColor Blue
    wsl --install -d Ubuntu-22.04
    Write-Host "Ubuntu installed. Please complete the Ubuntu setup and run this script again." -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "Ubuntu already installed" -ForegroundColor Green
}

# Check if winget is available
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Error: winget not found. Please install App Installer from Microsoft Store" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Installing Windows applications..." -ForegroundColor Blue

# Development Tools
Write-Host "Installing development tools..." -ForegroundColor Cyan

$apps = @(
    @{Name="Git.Git"; Display="Git for Windows"},
    @{Name="Microsoft.VisualStudioCode"; Display="VS Code"},
    @{Name="Cursor.Cursor"; Display="Cursor"},
    @{Name="Microsoft.PowerShell"; Display="PowerShell 7"},
    @{Name="Microsoft.WindowsTerminal"; Display="Windows Terminal"}
)

foreach ($app in $apps) {
    Write-Host "  - $($app.Display)..." -ForegroundColor Gray
    winget install --id $app.Name --silent --accept-package-agreements --accept-source-agreements
}

# Docker Desktop
Write-Host "Installing Docker Desktop..." -ForegroundColor Cyan
winget install --id Docker.DockerDesktop --silent --accept-package-agreements --accept-source-agreements

# Browsers
Write-Host "Installing browsers..." -ForegroundColor Cyan
winget install --id Google.Chrome --silent --accept-package-agreements --accept-source-agreements
winget install --id Mozilla.Firefox --silent --accept-package-agreements --accept-source-agreements

# Utilities
Write-Host "Installing utilities..." -ForegroundColor Cyan
$utils = @(
    @{Name="7zip.7zip"; Display="7zip"},
    @{Name="Microsoft.Sysinternals"; Display="Sysinternals Suite"},
    @{Name="voidtools.Everything"; Display="Everything Search"}
)

foreach ($util in $utils) {
    Write-Host "  - $($util.Display)..." -ForegroundColor Gray
    winget install --id $util.Name --silent --accept-package-agreements --accept-source-agreements
}

# Install Oh My Posh for PowerShell
Write-Host ""
Write-Host "Installing Oh My Posh..." -ForegroundColor Blue
winget install --id JanDeDobbeleer.OhMyPosh --silent --accept-package-agreements --accept-source-agreements

# Install Nerd Fonts
Write-Host "Installing MesloLGS NF font..." -ForegroundColor Blue
oh-my-posh font install meslo

# Configure PowerShell Profile
Write-Host ""
Write-Host "Configuring PowerShell profile..." -ForegroundColor Blue
$profilePath = $PROFILE.CurrentUserAllHosts
$profileDir = Split-Path -Parent $profilePath

if (!(Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$dotfilesProfile = "$HOME\.dotfiles\windows\Microsoft.PowerShell_profile.ps1"
if (Test-Path $dotfilesProfile) {
    Copy-Item -Path $dotfilesProfile -Destination $profilePath -Force
    Write-Host "PowerShell profile configured" -ForegroundColor Green
}

# Configure Windows Terminal
Write-Host "Configuring Windows Terminal..." -ForegroundColor Blue
$terminalSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$dotfilesTerminalSettings = "$HOME\.dotfiles\windows\terminal-settings.json"

if ((Test-Path $terminalSettings) -and (Test-Path $dotfilesTerminalSettings)) {
    Copy-Item -Path $terminalSettings -Destination "$terminalSettings.backup" -Force
    Copy-Item -Path $dotfilesTerminalSettings -Destination $terminalSettings -Force
    Write-Host "Windows Terminal configured (backup created)" -ForegroundColor Green
}

# Setup dotfiles in WSL
Write-Host ""
Write-Host "Setting up dotfiles in WSL..." -ForegroundColor Blue
Write-Host "Running Linux bootstrap in WSL..." -ForegroundColor Cyan

$wslSetup = @"
#!/bin/bash
if [ ! -d ~/.dotfiles ]; then
    ln -s /mnt/c/Users/$env:USERNAME/.dotfiles ~/.dotfiles
fi
cd ~/.dotfiles/linux
chmod +x bootstrap.sh
./bootstrap.sh
"@

$wslSetup | wsl bash

Write-Host ""
Write-Host "================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Restart Windows Terminal" -ForegroundColor White
Write-Host "2. Open Docker Desktop and enable WSL2 integration" -ForegroundColor White
Write-Host "3. In WSL, run: code --install-extension ms-vscode-remote.remote-wsl" -ForegroundColor White
Write-Host "4. Generate SSH key: ssh-keygen -t ed25519" -ForegroundColor White
Write-Host ""
Write-Host "To enter WSL: wsl" -ForegroundColor Cyan
Write-Host "To open VS Code in WSL: wsl code ." -ForegroundColor Cyan
