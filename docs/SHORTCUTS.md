# Keyboard Shortcuts & Commands Cheat Sheet

Quick reference for common DevOps workflows.

## Shell (Zsh)

### Navigation
```bash
Ctrl+A          # Start of line
Ctrl+E          # End of line
Ctrl+U          # Delete to start
Ctrl+K          # Delete to end
Ctrl+W          # Delete word backward
Ctrl+R          # Reverse search history
Ctrl+L          # Clear screen
```

### Custom Functions (type `aliases` to see all)
```bash
mkcd <dir>      # Make directory and cd into it
extract <file>  # Extract any archive type
killport 8080   # Kill process on port
gcap "msg"      # Git add, commit, push
```

## Tmux (Prefix: Ctrl+A)

### Session Management
```bash
Ctrl+A d        # Detach session
Ctrl+A $        # Rename session
Ctrl+A s        # Session selector
Ctrl+A (        # Previous session
Ctrl+A )        # Next session
```

### Window Management
```bash
Ctrl+A c        # New window
Ctrl+A ,        # Rename window
Ctrl+A n        # Next window
Ctrl+A p        # Previous window
Ctrl+A 0-9      # Switch to window #
Ctrl+A &        # Kill window
```

### Pane Management
```bash
Ctrl+A |        # Split vertical
Ctrl+A -        # Split horizontal
Ctrl+A h/j/k/l  # Navigate panes (vim-style)
Ctrl+A H/J/K/L  # Resize panes
Ctrl+A z        # Zoom pane
Ctrl+A x        # Kill pane
```

### Custom DevOps Shortcuts
```bash
Ctrl+A K        # kubectl get pods -A
Ctrl+A D        # docker ps
Ctrl+A 9        # k9s
Ctrl+A T        # btop
```

### Copy Mode
```bash
Ctrl+A [        # Enter copy mode
v               # Start selection
y               # Copy to clipboard
q               # Exit copy mode
```

## Vim (Leader: Space)

### Essential
```bash
:w              # Save
:q              # Quit
:wq             # Save and quit
:q!             # Quit without saving
Space + /       # Clear search highlighting
```

### Navigation
```bash
gg              # Top of file
G               # Bottom of file
0               # Start of line
$               # End of line
w/b             # Next/previous word
Ctrl+d/u        # Page down/up
```

### Editing
```bash
i/a             # Insert before/after cursor
o/O             # New line below/above
dd              # Delete line
yy              # Copy line
p               # Paste
u               # Undo
Ctrl+r          # Redo
```

### Custom (Leader = Space)
```bash
Space + w       # Save
Space + q       # Quit
Space + y       # Copy to clipboard
Space + p       # Paste from clipboard
Space + bn/bp   # Next/previous buffer
Space + ev      # Edit vimrc
```

### DevOps Specific
```bash
:FormatJSON     # Pretty print JSON
:FormatYAML     # Pretty print YAML
:TrimWhitespace # Remove trailing spaces
```

## Kubectl

### Shortcuts (Oh My Zsh plugin)
```bash
k               # kubectl
kg              # kubectl get
kd              # kubectl describe
kdel            # kubectl delete
kl              # kubectl logs
ke              # kubectl exec
kgp             # kubectl get pods
kgn             # kubectl get nodes
kgs             # kubectl get svc
```

### Custom Functions
```bash
kln <name>      # Logs by partial pod name
kexn <name>     # Exec into pod by partial name
ksecdec <s> <k> # Decode secret
kdebug          # Run debug pod
```

## Docker

### Basic
```bash
d               # docker
dc              # docker-compose
dps             # docker ps
di              # docker images
drm             # docker rm
drmi            # docker rmi
```

### Custom Functions
```bash
dsh <container> # Shell into container
dbash <c>       # Bash into container
```

## Git

### Shortcuts (Oh My Zsh plugin)
```bash
g               # git
gst             # git status
ga              # git add
gcam            # git commit -am
gp              # git push
gl              # git pull
gco             # git checkout
gcb             # git checkout -b
gd              # git diff
glog            # git log --oneline --graph
```

### Custom
```bash
gcap "msg"      # git add . && commit && push
```

## AWS CLI

### Custom Functions
```bash
awswho          # Show current identity
ec2ls           # List EC2 instances
eksls           # List EKS clusters
ecrlogin        # Login to ECR
s3tree <bucket> # Show S3 bucket tree
```

## Terraform/OpenTofu

### Basic
```bash
tofu init       # Initialize
tofu plan       # Plan changes
tofu apply      # Apply changes
tofu destroy    # Destroy resources
tofu fmt        # Format files
tofu validate   # Validate syntax
```

## macOS

### System
```bash
Cmd+Space       # Spotlight
Cmd+Tab         # Switch apps
Cmd+`           # Switch windows
Cmd+Q           # Quit app
Cmd+W           # Close window
```

### Screenshots
```bash
Cmd+Shift+3     # Full screen
Cmd+Shift+4     # Selection
Cmd+Shift+5     # Screenshot menu
```

### Finder
```bash
Cmd+Shift+.     # Show hidden files
Cmd+Shift+G     # Go to folder
Cmd+Up          # Parent directory
Cmd+Down        # Open folder
```

## Rectangle (Window Management)

```bash
Ctrl+Opt+Left       # Left half
Ctrl+Opt+Right      # Right half
Ctrl+Opt+Up         # Top half
Ctrl+Opt+Down       # Bottom half
Ctrl+Opt+Return     # Maximize
Ctrl+Opt+C          # Center
Ctrl+Opt+→          # Next display
```

## 1Password CLI

```bash
# Sign in
op signin

# Read secret
op read "op://vault/item/field"

# List items
op item list

# Get item
op item get "Item Name"

# Use in scripts
export API_KEY=$(op read "op://Personal/API Key/credential")
```

## Kubernetes Context Switching

```bash
# kubectx (installed)
kubectx                 # List contexts
kubectx <context>       # Switch context
kubectx -               # Previous context

# kubens (installed)
kubens                  # List namespaces
kubens <namespace>      # Switch namespace
kubens -                # Previous namespace
```

## Pro Tips

1. **fzf everywhere**: Many commands support fuzzy finding with fzf
   - `Ctrl+R` - command history
   - `Ctrl+T` - file search
   - `**<Tab>` - auto-completion

2. **zoxide**: Smart directory jumping
   - `z <partial>` - jump to frequent directory
   - `zi` - interactive directory picker

3. **Custom functions**: Type `aliases` to see all custom shortcuts

4. **Help**: Most tools support `--help` or `-h`
   - `kubectl --help`
   - `docker run --help`
   - `git commit --help`

5. **Man pages**: Read the manual
   - `man kubectl`
   - `man git`
   - `tldr kubectl` - simplified version
