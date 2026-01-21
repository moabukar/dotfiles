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
    @{Name="Git.Git"; Display="Git for Windows (includes Git Bash)"},
    @{Name="Microsoft.VisualStudioCode"; Display="VS Code"},
    @{Name="Cursor.Cursor"; Display="Cursor"},
    @{Name="Microsoft.PowerShell"; Display="PowerShell 7"},
    @{Name="Microsoft.WindowsTerminal"; Display="Windows Terminal"}
)

foreach ($app in $apps) {
    Write-Host "  - $($app.Display)..." -ForegroundColor Gray
    winget install --id $app.Name --silent --accept-package-agreements --accept-source-agreements
}

# Programming Languages & Runtimes
Write-Host "Installing programming languages..." -ForegroundColor Cyan
$languages = @(
    @{Name="OpenJS.NodeJS"; Display="Node.js"},
    @{Name="Python.Python.3.12"; Display="Python 3.12"},
    @{Name="GoLang.Go"; Display="Go"},
    @{Name="Rustlang.Rust.MSVC"; Display="Rust"},
    @{Name="OpenJDK.JDK"; Display="OpenJDK"}
)

foreach ($lang in $languages) {
    Write-Host "  - $($lang.Display)..." -ForegroundColor Gray
    winget install --id $lang.Name --silent --accept-package-agreements --accept-source-agreements
}

# Container & Orchestration
Write-Host "Installing container tools..." -ForegroundColor Cyan
winget install --id Docker.DockerDesktop --silent --accept-package-agreements --accept-source-agreements

# Cloud CLIs
Write-Host "Installing cloud CLIs..." -ForegroundColor Cyan
$cloudTools = @(
    @{Name="Amazon.AWSCLI"; Display="AWS CLI"},
    @{Name="Microsoft.AzureCLI"; Display="Azure CLI"},
    @{Name="Google.CloudSDK"; Display="Google Cloud SDK"}
)

foreach ($tool in $cloudTools) {
    Write-Host "  - $($tool.Display)..." -ForegroundColor Gray
    winget install --id $tool.Name --silent --accept-package-agreements --accept-source-agreements
}

# DevOps & Infrastructure Tools
Write-Host "Installing DevOps tools..." -ForegroundColor Cyan
$devopsTools = @(
    @{Name="Hashicorp.Terraform"; Display="Terraform"},
    @{Name="Kubernetes.kubectl"; Display="kubectl"},
    @{Name="Helm.Helm"; Display="Helm"}
)

foreach ($tool in $devopsTools) {
    Write-Host "  - $($tool.Display)..." -ForegroundColor Gray
    winget install --id $tool.Name --silent --accept-package-agreements --accept-source-agreements
}

# Database & API Tools
Write-Host "Installing database & API tools..." -ForegroundColor Cyan
$dbTools = @(
    @{Name="Postman.Postman"; Display="Postman"},
    @{Name="dbeaver.dbeaver"; Display="DBeaver"},
    @{Name="Insomnia.Insomnia"; Display="Insomnia"}
)

foreach ($tool in $dbTools) {
    Write-Host "  - $($tool.Display)..." -ForegroundColor Gray
    winget install --id $tool.Name --silent --accept-package-agreements --accept-source-agreements
}

# Browsers
Write-Host "Installing browsers..." -ForegroundColor Cyan
winget install --id Google.Chrome --silent --accept-package-agreements --accept-source-agreements
winget install --id Mozilla.Firefox --silent --accept-package-agreements --accept-source-agreements

# Communication & Productivity
Write-Host "Installing communication tools..." -ForegroundColor Cyan
$commTools = @(
    @{Name="Notion.Notion"; Display="Notion"},
    @{Name="SlackTechnologies.Slack"; Display="Slack"},
    @{Name="Zoom.Zoom"; Display="Zoom"},
    @{Name="Microsoft.Teams"; Display="Microsoft Teams"}
)

foreach ($tool in $commTools) {
    Write-Host "  - $($tool.Display)..." -ForegroundColor Gray
    winget install --id $tool.Name --silent --accept-package-agreements --accept-source-agreements
}

# Utilities
Write-Host "Installing utilities..." -ForegroundColor Cyan
$utils = @(
    @{Name="7zip.7zip"; Display="7zip"},
    @{Name="Microsoft.Sysinternals"; Display="Sysinternals Suite"},
    @{Name="voidtools.Everything"; Display="Everything Search"},
    @{Name="AgileBits.1Password"; Display="1Password"},
    @{Name="Microsoft.PowerToys"; Display="PowerToys"}
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

# Enable Windows Developer Features
Write-Host ""
Write-Host "Enabling Windows Developer Features..." -ForegroundColor Blue

# Enable Developer Mode
Write-Host "Enabling Developer Mode..." -ForegroundColor Cyan
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "AllowDevelopmentWithoutDevLicense" -Value 1 -Type DWord

# Enable long paths
Write-Host "Enabling long paths..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -Type DWord

# Configure Git Bash integration in Windows Terminal
Write-Host "Configuring Git Bash in Windows Terminal..." -ForegroundColor Cyan
$gitBashPath = "C:\Program Files\Git\bin\bash.exe"
if (Test-Path $gitBashPath) {
    Write-Host "Git Bash found at: $gitBashPath" -ForegroundColor Green
} else {
    Write-Host "Git Bash not found, it will be available after Git installation completes" -ForegroundColor Yellow
}

# Install VS Code Extensions
Write-Host ""
Write-Host "Installing VS Code extensions..." -ForegroundColor Blue
$codeCmd = Get-Command code -ErrorAction SilentlyContinue
if ($codeCmd) {
    $extensions = @(
        "ms-vscode-remote.remote-wsl",
        "ms-vscode-remote.remote-containers",
        "ms-azuretools.vscode-docker",
        "hashicorp.terraform",
        "ms-kubernetes-tools.vscode-kubernetes-tools",
        "redhat.vscode-yaml",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint",
        "ms-python.python",
        "golang.go",
        "rust-lang.rust-analyzer",
        "eamodio.gitlens",
        "github.copilot"
    )

    foreach ($ext in $extensions) {
        Write-Host "  - Installing $ext..." -ForegroundColor Gray
        code --install-extension $ext --force
    }
    Write-Host "VS Code extensions installed" -ForegroundColor Green
} else {
    Write-Host "VS Code command not found yet. Install extensions manually after restart." -ForegroundColor Yellow
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
Write-Host "Installed:" -ForegroundColor Cyan
Write-Host "  Core Tools: Git (+ Git Bash), VS Code, Cursor, PowerShell 7, Windows Terminal" -ForegroundColor White
Write-Host "  Languages: Node.js, Python, Go, Rust, Java" -ForegroundColor White
Write-Host "  DevOps: Docker, kubectl, Helm, Terraform, AWS CLI, Azure CLI, GCloud SDK" -ForegroundColor White
Write-Host "  Database: DBeaver, Postman, Insomnia" -ForegroundColor White
Write-Host "  Communication: Slack, Teams, Zoom, Notion" -ForegroundColor White
Write-Host "  Utilities: 1Password, PowerToys, 7zip, Everything Search, Sysinternals" -ForegroundColor White
Write-Host "  WSL2: Ubuntu 22.04 with full dotfiles setup" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. RESTART YOUR COMPUTER to complete all installations" -ForegroundColor White
Write-Host "2. Open Docker Desktop and enable WSL2 integration (Settings -> Resources -> WSL Integration)" -ForegroundColor White
Write-Host "3. Generate SSH key: ssh-keygen -t ed25519 -C 'your_email@example.com'" -ForegroundColor White
Write-Host "4. Configure Git: git config --global user.name 'Your Name' && git config --global user.email 'your_email@example.com'" -ForegroundColor White
Write-Host "5. Sign in to 1Password, GitHub Copilot, and cloud CLIs" -ForegroundColor White
Write-Host ""
Write-Host "Quick Commands:" -ForegroundColor Cyan
Write-Host "  Enter WSL Ubuntu: wsl" -ForegroundColor White
Write-Host "  Open VS Code in WSL: code ." -ForegroundColor White
Write-Host "  Open Git Bash: Start -> Git Bash" -ForegroundColor White
Write-Host "  PowerShell Profile: notepad `$PROFILE" -ForegroundColor White
Write-Host "  Windows Terminal Settings: Ctrl+," -ForegroundColor White
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Cyan
Write-Host "  Windows Setup: ~/.dotfiles/windows/README.md" -ForegroundColor White
Write-Host "  Linux Setup: ~/.dotfiles/linux/README.md" -ForegroundColor White
Write-Host "  Guides: ~/.dotfiles/docs/" -ForegroundColor White
