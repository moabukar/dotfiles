# Dotfiles - Windows Setup

Automated development environment setup for Windows 11 with WSL2.

## Prerequisites

- Windows 11 (or Windows 10 version 2004+)
- Administrator access

## Quick Start

### 1. Install WSL2 (PowerShell as Administrator)

```powershell
# Clone this repo to Windows first
git clone https://github.com/yourusername/dotfiles.git $HOME\.dotfiles

# Run the setup script
cd $HOME\.dotfiles\windows
.\setup.ps1
```

This will:

- Install WSL2
- Install Ubuntu 22.04
- Set up Windows Terminal
- Install Windows tools (Git, VS Code, Docker Desktop, etc.)

### 2. Setup Inside WSL2

```bash
# Inside WSL2 Ubuntu
cd ~/.dotfiles/linux
./bootstrap.sh
```

## What Gets Installed

### Windows (via winget/Chocolatey)

- **Terminal:** Windows Terminal
- **Editors:** VS Code, Cursor
- **Tools:** Git for Windows, PowerShell 7
- **Containers:** Docker Desktop
- **Browsers:** Chrome, Firefox
- **Utils:** 7zip, Everything search, Sysinternals

### WSL2 Ubuntu

- Full Linux DevOps environment (see `linux/README.md`)
- Zsh + Oh My Zsh + Powerlevel10k
- Docker, Kubernetes tools
- All CLI tools and languages

## Windows Terminal Configuration

The setup includes a pre-configured `settings.json` for Windows Terminal with:

- Ubuntu WSL as default profile
- Custom color scheme
- Useful keybindings
- Acrylic transparency

Located at: `windows/terminal-settings.json`

## PowerShell Profile

Custom PowerShell profile with:

- Oh My Posh theme
- Useful aliases
- Directory navigation helpers

Located at: `windows/Microsoft.PowerShell_profile.ps1`

## Post-Setup

### 1. Configure Windows Terminal Font

Download and install **MesloLGS NF** fonts:

- Download from: https://github.com/romkatv/powerlevel10k#fonts
- Double-click each `.ttf` file and click "Install"
- Set in Windows Terminal: Settings → Ubuntu profile → Appearance → Font face

### 2. Docker Desktop WSL2 Integration

- Open Docker Desktop
- Settings → Resources → WSL Integration
- Enable for your Ubuntu distribution

### 3. VS Code WSL Extension

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

Then in WSL: `code .` to open VS Code connected to WSL

### 4. Git Credentials

Git credentials are shared between Windows and WSL. Configure once:

```bash
# In WSL
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
```

## Tips & Tricks

### Access Windows Files from WSL

```bash
cd /mnt/c/Users/YourUsername/
```

### Access WSL Files from Windows

```
\\wsl$\Ubuntu\home\username
```

### Open Windows Explorer from WSL

```bash
explorer.exe .
```

### Run Windows Commands from WSL

```bash
cmd.exe /c dir
powershell.exe -Command Get-Process
```

### Use WSL from PowerShell

```powershell
wsl ls -la
wsl --distribution Ubuntu
```

## Differences from Native Linux

- Docker runs via Docker Desktop (not native)
- Filesystem performance (use WSL filesystem, not /mnt/c)
- Windows paths accessible via /mnt/
- Can run Windows executables from WSL
- Shared git credentials

## Updating

### Update Windows Tools

```powershell
winget upgrade --all
```

### Update WSL

```bash
# In WSL
sudo apt update && sudo apt upgrade -y
~/.dotfiles/linux/scripts/update.sh
```

## Troubleshooting

### WSL2 not starting

```powershell
# Restart WSL
wsl --shutdown
wsl
```

### Slow filesystem

- Move projects to WSL filesystem (`~/projects` not `/mnt/c/...`)
- Use `\\wsl$\` to access from Windows

### Docker not working

- Ensure WSL2 integration is enabled in Docker Desktop
- Restart Docker Desktop

### Windows Terminal not using correct font

- Manually select "MesloLGS NF" in settings
- Restart Windows Terminal

## Tested On

- Windows 11 22H2
- WSL2 with Ubuntu 22.04 LTS
- Docker Desktop 4.25+
- Windows Terminal 1.18+
