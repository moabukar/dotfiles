# DevOps Engineer Productivity Guide

This guide is a collection of productivity tips and tricks that I have found to be helpful in my own workflow.

## Shell Productivity

### Oh My Zsh Plugins (Already Configured)

These are loaded in `.zshrc` but worth understanding:
- `terraform` - tf aliases and completion
- `kubectl` - k8s aliases (k=kubectl, kgp=get pods, etc.)
- `docker` - docker aliases and completion
- `git` - g=git, gst=git status, etc.
- `aws` - AWS CLI completion
- `golang`, `rust`, `node` - language-specific helpers

### Custom Functions Worth Adding
Add these to your workflow:

**SSH Config Management:**
```bash
# Jump to ssh config
alias sshconf='vim ~/.ssh/config'

# Copy SSH key to clipboard
alias sshcopy='cat ~/.ssh/id_ed25519.pub | pbcopy'
```

**Quick Context Switching:**

```bash
# Quick project switcher
proj() {
  local project=$(find ~/Documents ~/coderco -maxdepth 2 -type d | fzf)
  cd "$project" && ls -la
}

# Open project in Cursor
cursorproj() {
  local project=$(find ~/Documents ~/coderco -maxdepth 2 -type d | fzf)
  cursor "$project"
}
```

## Git Workflow Enhancements

### Pre-commit Hooks

Set these up per-repo:
```bash
# Install pre-commit framework (already in Brewfile)
cd your-repo
pre-commit install

# Example .pre-commit-config.yaml:
# - terraform fmt & validate
# - shellcheck for bash scripts
# - yamllint for YAML
# - hadolint for Dockerfiles
# - tfsec/checkov for security
```

### Git Config Improvements

Add to `.gitconfig`:
```ini
[alias]
    # Quick amend
    amend = commit --amend --no-edit

    # Undo last commit but keep changes
    undo = reset HEAD~1 --soft

    # Clean merged branches
    cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master\\|develop' | xargs -n 1 git branch -d"

    # Better log
    lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

[delta]
    navigate = true
    light = false
    line-numbers = true
    side-by-side = true
```

## Kubernetes Productivity

### Context & Namespace Management

```bash
# Quick context switch with fzf
kctx() {
  kubectl config use-context $(kubectl config get-contexts -o name | fzf)
}

# Quick namespace switch
kns() {
  kubectl config set-context --current --namespace=$(kubectl get ns -o name | cut -d/ -f2 | fzf)
}

# Port-forward with autocomplete
kpf() {
  local pod=$(kubectl get pods -o name | fzf)
  local port=${1:-8080}
  kubectl port-forward "$pod" "$port:$port"
}
```

### Kubectl Plugins (via Krew)

Install these after running bootstrap:
```bash
# Already installed via Brewfile, now add plugins:
kubectl krew install ctx          # Better context switching
kubectl krew install ns           # Better namespace switching
kubectl krew install tree         # Resource hierarchy
kubectl krew install neat         # Clean kubectl output
kubectl krew install sick-pods    # Find problematic pods
kubectl krew install view-secret  # Decode secrets easily
kubectl krew install tail         # Tail logs
kubectl krew install exec-as      # Execute as serviceaccount
```

## AWS Productivity

### AWS CLI Config

`~/.aws/config`:
```ini
[default]
region = us-east-1
output = json

[profile dev]
region = us-east-1
role_arn = arn:aws:iam::ACCOUNT:role/DevRole
source_profile = default

[profile prod]
region = us-east-1
role_arn = arn:aws:iam::ACCOUNT:role/ProdRole
source_profile = default
mfa_serial = arn:aws:iam::ACCOUNT:mfa/your-user
```

### AWS Aliases

```bash
# Quick profile switcher
awsprofile() {
  export AWS_PROFILE=$(grep '\[profile' ~/.aws/config | sed 's/\[profile \(.*\)\]/\1/' | fzf)
  echo "Switched to profile: $AWS_PROFILE"
}

# SSM session to EC2
ssm() {
  local instance=$(aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=running" \
    --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0]]' \
    --output text | fzf | awk '{print $1}')
  aws ssm start-session --target "$instance"
}
```

## Secrets Management

### SOPS with Age

```bash
# Initialize age key (first time)
age-keygen -o ~/.config/sops/age/keys.txt

# .sops.yaml in your repo:
creation_rules:
  - path_regex: .*\.yaml
    age: 'age1...' # your public key
```

### Environment Variables

Create env file per project:
```bash
# ~/projects/myapp/.envrc (direnv will auto-load)
export AWS_PROFILE=dev
export KUBECONFIG=~/.kube/dev-cluster
export TF_VAR_environment=dev
export DATABASE_URL=postgres://localhost/myapp_dev
```

## Monitoring & Observability

### Quick Dashboards

Add these to your workflow:

**System Dashboard:**
```bash
alias dash='btop'  # Already aliased as 'top'
```

**Docker Dashboard:**

```bash
# Install via: brew install lazydocker (if you want)
alias dockdash='lazydocker'
```

**K8s Dashboard:**

```bash
alias k8sdash='k9s'  # Already aliased
```

## Documentation

### Personal Wiki/Runbooks

Keep these in your dotfiles or separate repo:
```
~/Documents/runbooks/
├── aws/
│   ├── rds-restore.md
│   ├── s3-lifecycle.md
├── kubernetes/
│   ├── cert-manager-renewal.md
│   ├── pod-stuck-terminating.md
├── terraform/
│   ├── state-recovery.md
│   └── module-upgrade.md
└── incidents/
    └── yyyy-mm-dd-incident-name.md
```

### Bookmark These

- https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- https://github.com/bregman-arie/devops-exercises
- https://roadmap.sh/devops
- https://12factor.net/

## Browser Extensions

### For Chrome/Firefox

- **ModHeader** - modify HTTP headers (testing auth, CORS)
- **JSON Formatter** - pretty print JSON
- **Wappalyzer** - detect tech stacks
- **AWS Extend Switch Roles** - quick AWS account switching
- **Octotree** - GitHub code tree
- **Refined GitHub** - GitHub enhancements

## VS Code / Cursor Extensions

Already configured, but make sure you understand:
- **Terraform** - syntax, linting, formatting
- **YAML** - validation, k8s schema
- **Docker** - Dockerfile linting, compose support
- **Kubernetes** - manifest validation
- **GitLens** - git history in-line
- **Remote SSH** - edit files on remote servers
- **Better Comments** - highlight TODOs, FIXMEs

## Terminal Multiplexing

### Tmux Workflow

```bash
# Create session per project
tmux new -s myproject

# Window layout:
# 0: editor (vim/cursor)
# 1: logs (stern/kubectl logs)
# 2: commands (kubectl/terraform)
# 3: monitoring (k9s)

# Attach from anywhere:
alias tm='tmux attach || tmux new'
```

### Tmux Config Additions

Add to `~/.tmux.conf`:
```
# Better split commands
bind | split-window -h
bind - split-window -v

# Mouse support
set -g mouse on

# Vim-like pane switching
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
```

## Infrastructure as Code

### Terraform Workflow
```bash
# Use workspaces
tf workspace new dev
tf workspace new staging
tf workspace new prod

# Always plan with out file
alias tfp='terraform plan -out=tfplan'
alias tfa='terraform apply tfplan'

# Use atlantis for PR-based workflows
# Set up in your CI/CD
```

### Pre-commit for IaC
`.pre-commit-config.yaml`:
```yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.0
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_tflint
      - id: terraform_docs

  - repo: https://github.com/aquasecurity/tfsec
    rev: v1.28.1
    hooks:
      - id: tfsec
```

## CI/CD

### GitHub Actions Local Testing
```bash
# Test workflows locally before pushing
act -l                    # list workflows
act push                  # simulate push event
act -j test              # run specific job
```

### Pipeline Debugging
```bash
# GitHub Actions logs
gh run list
gh run view <run-id>
gh run watch

# GitLab CI logs
glab ci trace <job-id>
```

## Mac-Specific Productivity

### Keyboard Shortcuts
Set these up in System Settings:
- **Cmd+Shift+.** - Show hidden files in Finder
- **Cmd+Opt+D** - Toggle Dock hiding
- **Rectangle shortcuts** - window management

### Alfred Workflows (Alternative to Spotlight)
If you want more than Spotlight:
```bash
brew install --cask alfred
```

Workflows to get:
- AWS Console Services
- Docker containers
- Kubernetes contexts
- GitHub repos
- Terraform workspace switcher

### Raycast (Modern Alternative)
```bash
brew install --cask raycast
```

Extensions:
- AWS Console
- GitHub
- Kubernetes
- Terraform

## Productivity Habits

### Morning Routine
```bash
# Add to .zshrc or run manually
morning() {
  echo "🌅 Morning DevOps Check"
  echo ""
  echo "☁️  AWS Identity:"
  aws sts get-caller-identity
  echo ""
  echo "🎯 K8s Context:"
  kubectl config current-context
  echo ""
  echo "🐳 Docker:"
  docker ps
  echo ""
  echo "📊 Disk Space:"
  df -h | grep -E '^/dev/|Filesystem'
}
```

### End of Day Cleanup
```bash
eod() {
  echo "🌙 End of Day Cleanup"

  # Commit any WIP
  echo "Any uncommitted changes?"
  git status -s

  # Clean docker
  echo "Cleaning Docker..."
  docker system prune -f

  # Clean brew
  echo "Cleaning Homebrew..."
  brew cleanup

  # Show tomorrow's calendar (if using 'gcalcli')
  # gcalcli agenda tomorrow
}
```

## Security Best Practices

### SSH Config
`~/.ssh/config`:
```
# Global settings
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
  ServerAliveInterval 60
  ServerAliveCountMax 3

# Bastion pattern
Host bastion
  HostName bastion.example.com
  User admin
  IdentityFile ~/.ssh/bastion_key

Host prod-*
  ProxyJump bastion
  User admin
```

### GPG for Commit Signing
```bash
# Generate GPG key
gpg --full-generate-key

# Add to GitHub
gpg --armor --export YOUR_KEY_ID | pbcopy

# Configure git
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
```

## Learning & Staying Updated

### Resources to Follow
- **Weekly newsletters**: DevOps Weekly, KubeWeekly, Last Week in AWS
- **YouTube**: TechWorld with Nana, Cloud Native Computing Foundation
- **Podcasts**: Kubernetes Podcast, Arrested DevOps
- **Slack/Discord**: r/devops, Kubernetes Slack, CNCF Slack

### Practice Environments
```bash
# Local K8s clusters
kind create cluster --name playground
k3d cluster create dev

# LocalStack for AWS
docker run -d -p 4566:4566 localstack/localstack

# Terraform testing
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

## Performance Optimization

### Shell Startup Time
```bash
# Benchmark your shell
time zsh -i -c exit

# Lazy load slow tools
# Example: instead of "eval $(pyenv init -)", lazy load it:
pyenv() {
  eval "$(command pyenv init -)"
  pyenv "$@"
}
```

### Reduce Docker Image Size
```dockerfile
# Multi-stage builds
FROM golang:1.21 as builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -o app

FROM alpine:3.18
COPY --from=builder /app/app /app
CMD ["/app"]
```

## Conclusion

The difference between good and great DevOps engineers isn't just tools—it's workflows, automation and continuously improving your environment.
