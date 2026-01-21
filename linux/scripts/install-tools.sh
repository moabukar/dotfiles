#!/bin/bash

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# Install Node.js via nvm
info "Installing Node.js via nvm..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    success "Node.js installed"
else
    success "nvm already installed"
fi

# Install Go
info "Installing Go..."
if ! command -v go &> /dev/null; then
    GO_VERSION="1.21.5"
    wget "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
    success "Go installed"
else
    success "Go already installed"
fi

# Install Rust
info "Installing Rust..."
if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    success "Rust installed"
else
    success "Rust already installed"
fi

# Install Python tools
info "Installing Python tools..."
sudo apt install -y python3-pip python3-venv
pip3 install --user pipx
python3 -m pipx ensurepath

# Install kubectl
info "Installing kubectl..."
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    success "kubectl installed"
else
    success "kubectl already installed"
fi

# Install Helm
info "Installing Helm..."
if ! command -v helm &> /dev/null; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    success "Helm installed"
else
    success "Helm already installed"
fi

# Install k9s
info "Installing k9s..."
if ! command -v k9s &> /dev/null; then
    wget https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz -O /tmp/k9s.tar.gz
    tar -xzf /tmp/k9s.tar.gz -C /tmp
    sudo mv /tmp/k9s /usr/local/bin/
    rm /tmp/k9s.tar.gz
    success "k9s installed"
else
    success "k9s already installed"
fi

# Install kubectx and kubens
info "Installing kubectx and kubens..."
sudo wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx -O /usr/local/bin/kubectx
sudo wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens -O /usr/local/bin/kubens
sudo chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens
success "kubectx and kubens installed"

# Install stern
info "Installing stern..."
if ! command -v stern &> /dev/null; then
    STERN_VERSION="1.28.0"
    wget "https://github.com/stern/stern/releases/download/v${STERN_VERSION}/stern_${STERN_VERSION}_linux_amd64.tar.gz" -O /tmp/stern.tar.gz
    tar -xzf /tmp/stern.tar.gz -C /tmp
    sudo mv /tmp/stern /usr/local/bin/
    rm /tmp/stern.tar.gz
    success "stern installed"
else
    success "stern already installed"
fi

# Install OpenTofu
info "Installing OpenTofu..."
if ! command -v tofu &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o /tmp/install-opentofu.sh
    chmod +x /tmp/install-opentofu.sh
    sudo /tmp/install-opentofu.sh --install-method deb
    rm /tmp/install-opentofu.sh
    success "OpenTofu installed"
else
    success "OpenTofu already installed"
fi

# Install AWS CLI
info "Installing AWS CLI..."
if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    unzip -q /tmp/awscliv2.zip -d /tmp
    sudo /tmp/aws/install
    rm -rf /tmp/aws /tmp/awscliv2.zip
    success "AWS CLI installed"
else
    success "AWS CLI already installed"
fi

# Install Azure CLI
info "Installing Azure CLI..."
if ! command -v az &> /dev/null; then
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    success "Azure CLI installed"
else
    success "Azure CLI already installed"
fi

# Install GitHub CLI
info "Installing GitHub CLI..."
if ! command -v gh &> /dev/null; then
    type -p curl >/dev/null || sudo apt install curl -y
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh -y
    success "GitHub CLI installed"
else
    success "GitHub CLI already installed"
fi

# Install better CLI tools
info "Installing better CLI tools..."

# bat
if ! command -v bat &> /dev/null; then
    sudo apt install -y bat
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat
fi

# eza
if ! command -v eza &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
fi

# fzf
if ! command -v fzf &> /dev/null; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
fi

# ripgrep
sudo apt install -y ripgrep

# fd-find
sudo apt install -y fd-find
mkdir -p ~/.local/bin
ln -sf "$(which fdfind)" ~/.local/bin/fd

# jq and yq
sudo apt install -y jq
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq

# httpie
sudo apt install -y httpie

# delta (better git diff)
DELTA_VERSION="0.16.5"
wget "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb" -O /tmp/delta.deb
sudo dpkg -i /tmp/delta.deb
rm /tmp/delta.deb

# zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# direnv
sudo apt install -y direnv

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf /tmp/lazygit.tar.gz -C /tmp
sudo install /tmp/lazygit /usr/local/bin
rm /tmp/lazygit.tar.gz /tmp/lazygit

# btop
sudo apt install -y btop

success "All tools installed!"
