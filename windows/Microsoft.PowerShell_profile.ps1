# PowerShell Profile for DevOps

# Oh My Posh
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomic.omp.json" | Invoke-Expression
}

# PSReadLine configuration
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    try {
        # These features require VT support and may not work in CI
        Set-PSReadLineOption -PredictionSource History -ErrorAction Stop
        Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction Stop
    } catch {
        # Silently skip prediction features in non-VT environments (CI)
    }
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# Aliases
Set-Alias -Name vim -Value nvim -ErrorAction SilentlyContinue
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name grep -Value Select-String
Set-Alias -Name touch -Value New-Item

# Custom Functions
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function mkcd ($dir) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Set-Location $dir
}

function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }

function dev { Set-Location ~/dev }
function docs { Set-Location ~/Documents }
function downloads { Set-Location ~/Downloads }

# Git aliases
function gs { git status }
function ga { git add $args }
function gc { git commit -m $args }
function gp { git push }
function gl { git pull }
function gco { git checkout $args }
function gcb { git checkout -b $args }
function gd { git diff }
function glog { git log --oneline --graph --all }

# Docker aliases
function d { docker $args }
function dc { docker-compose $args }
function dps { docker ps }
function dimg { docker images }
function dexec { docker exec -it $args }

# Kubernetes aliases
function k { kubectl $args }
function kgp { kubectl get pods $args }
function kgs { kubectl get svc $args }
function kgn { kubectl get nodes $args }
function kdp { kubectl describe pod $args }
function kl { kubectl logs $args }
function kx { kubectl exec -it $args }

# WSL shortcuts
function ubuntu { wsl -d Ubuntu }
function wslhome { Set-Location "\\wsl$\Ubuntu\home\$env:USER" }

# System info
function sysinfo {
    Write-Host "System Information" -ForegroundColor Cyan
    Write-Host "==================" -ForegroundColor Cyan
    Write-Host "OS: $(Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty Caption)"
    Write-Host "Version: $(Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty Version)"
    Write-Host "Uptime: $((Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime | ForEach-Object { "$($_.Days)d $($_.Hours)h $($_.Minutes)m" })"
    Write-Host "PowerShell: $($PSVersionTable.PSVersion)"
    Write-Host ""
    Write-Host "WSL Distributions:" -ForegroundColor Cyan
    wsl --list --verbose
}

# Update everything
function update-all {
    Write-Host "Updating Windows packages..." -ForegroundColor Blue
    winget upgrade --all

    Write-Host "Updating PowerShell modules..." -ForegroundColor Blue
    Update-Module -Force

    Write-Host "Updating WSL..." -ForegroundColor Blue
    wsl --update

    Write-Host "Updating Ubuntu in WSL..." -ForegroundColor Blue
    wsl sudo apt update && wsl sudo apt upgrade -y
}

# Welcome message
Write-Host "PowerShell DevOps Environment Loaded" -ForegroundColor Green
Write-Host "Type 'sysinfo' for system information" -ForegroundColor Gray
Write-Host "Type 'ubuntu' or 'wsl' to enter WSL" -ForegroundColor Gray
