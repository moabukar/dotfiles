# Additional DevOps Functions & Utilities
# Source this from .zshrc: source ~/.dotfiles/shell/aliases.sh

# Kubernetes - Partial name matching
kln() {
    kubectl logs -f "$(kubectl get pods | grep "$1" | head -1 | awk '{print $1}')"
}

kexn() {
    kubectl exec -it "$(kubectl get pods | grep "$1" | head -1 | awk '{print $1}')" -- /bin/sh
}

kbashexn() {
    kubectl exec -it "$(kubectl get pods | grep "$1" | head -1 | awk '{print $1}')" -- /bin/bash
}

# Kubernetes - Secret decoding
ksecdec() {
    kubectl get secret "$1" -o jsonpath="{.data.$2}" | base64 -d
}

ksecshow() {
    kubectl get secret "$1" -o json | jq -r '.data | to_entries[] | "\(.key): \(.value | @base64d)"'
}

# Kubernetes - Quick debug pod
kdebug() {
    kubectl run debug-pod --rm -it --image=alpine -- /bin/sh
}

# Docker - Shell helpers
dsh() {
    docker exec -it "$1" /bin/sh
}

dbash() {
    docker exec -it "$1" /bin/bash
}

# Terraform - Plan with output
tfpo() {
    terraform plan -out="${1:-tfplan}"
}

tfap() {
    terraform apply "${1:-tfplan}"
}

# Terraform - Targeted operations
tfpt() {
    terraform plan -target="$1"
}

tfat() {
    terraform apply -target="$1"
}

# AWS - Formatted outputs
awswho() {
    aws sts get-caller-identity
}

ec2ls() {
    aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==\`Name\`].Value|[0]]" --output table
}

ec2running() {
    aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].[InstanceId,Tags[?Key==\`Name\`].Value|[0],PrivateIpAddress]" --output table
}

eksls() {
    aws eks list-clusters --query "clusters" --output table
}

eksupdate() {
    aws eks update-kubeconfig --name "$1"
}

ecrlogin() {
    aws ecr get-login-password | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.$(aws configure get region).amazonaws.com
}

lambdals() {
    aws lambda list-functions --query "Functions[*].[FunctionName,Runtime,MemorySize]" --output table
}

s3tree() {
    aws s3 ls s3://"$1" --recursive | awk '{print $4}' | sed 's/[^\/]*$//' | sort -u
}

# Utility Functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Base64 encode/decode
b64e() {
    echo -n "$1" | base64
}

b64d() {
    echo "$1" | base64 -d && echo ""
}

# URL encode/decode
urlencode() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
}

urldecode() {
    python3 -c "import urllib.parse; print(urllib.parse.unquote('$1'))"
}

# Generate random password
genpass() {
    openssl rand -base64 "${1:-32}" | tr -d '=' | head -c "${1:-32}" && echo ""
}

# Kill process on port
killport() {
    lsof -ti:"$1" | xargs kill -9 2>/dev/null
}

# Find large files
largef() {
    find . -type f -size +"${1:-100M}" -exec ls -lh {} \; 2>/dev/null
}

# Directory sizes sorted
dirsizes() {
    du -sh */ 2>/dev/null | sort -h
}

# Git quick commit and push
gcap() {
    git add --all && git commit -m "$1" && git push
}

# Helm - quick install/upgrade
hui() {
    helm upgrade --install "$@"
}

# Show all custom aliases
aliases() {
    echo "Custom DevOps Functions:"
    echo ""
    echo "Kubernetes:"
    echo "  kln <partial>      - logs by partial pod name"
    echo "  kexn <partial>     - exec into pod by partial name"
    echo "  ksecdec <sec> <key> - decode secret value"
    echo "  ksecshow <secret>  - show all decoded secrets"
    echo "  kdebug             - run debug alpine pod"
    echo ""
    echo "Docker:"
    echo "  dsh <container>    - shell into container"
    echo "  dbash <container>  - bash into container"
    echo ""
    echo "Terraform:"
    echo "  tfpo [file]        - plan with output"
    echo "  tfap [file]        - apply from plan"
    echo "  tfpt <target>      - targeted plan"
    echo "  tfat <target>      - targeted apply"
    echo ""
    echo "AWS:"
    echo "  awswho             - get caller identity"
    echo "  ec2ls              - list EC2 instances"
    echo "  ec2running         - list running instances"
    echo "  eksls              - list EKS clusters"
    echo "  eksupdate <name>   - update kubeconfig"
    echo "  ecrlogin           - docker login to ECR"
    echo "  s3tree <bucket>    - show S3 bucket structure"
    echo ""
    echo "Utils:"
    echo "  mkcd <dir>         - mkdir and cd"
    echo "  extract <file>     - extract any archive"
    echo "  b64e/b64d          - base64 encode/decode"
    echo "  urlencode/urldecode - URL encode/decode"
    echo "  genpass [len]      - generate password"
    echo "  killport <port>    - kill process on port"
    echo "  largef [size]      - find large files"
    echo "  dirsizes           - directory sizes sorted"
    echo "  gcap <msg>         - git add, commit, push"
    echo ""
}

# kubectl/helm/terraform completion (only if not already set)
if command -v kubectl &> /dev/null; then
    if [ -n "$ZSH_VERSION" ]; then
        source <(kubectl completion zsh 2>/dev/null)
    fi
fi

if command -v helm &> /dev/null; then
    if [ -n "$ZSH_VERSION" ]; then
        source <(helm completion zsh 2>/dev/null)
    fi
fi

if command -v terraform &> /dev/null; then
    complete -C terraform terraform 2>/dev/null
    complete -C terraform tf 2>/dev/null
fi
