# Tmux Beginner's Guide for DevOps Engineers

A practical guide to terminal multiplexing for DevOps workflows.

## Why Tmux?

- **Persist sessions** - SSH disconnect? Your work keeps running
- **Multiple windows** - One SSH connection, many terminals
- **Split panes** - Monitor logs while running commands
- **Shared sessions** - Pair programming over SSH
- **Organize work** - One session per project

## Core Concepts

### Sessions
A collection of windows. You can detach and reattach.
```bash
tmux new -s myproject       # Create session named "myproject"
tmux attach -t myproject    # Reattach to session
tmux ls                     # List sessions
```

### Windows
Like browser tabs. Each session has multiple windows.
```
0: editor   1: logs   2: terminal   3: monitoring
```

### Panes
Split a window into multiple sections.
```
┌─────────────────────┬──────────────┐
│                     │              │
│   Editor            │   Logs       │
│                     │              │
├─────────────────────┴──────────────┤
│   Commands                          │
└─────────────────────────────────────┘
```

### Prefix Key
Tmux commands start with a prefix: `Ctrl+a` (in our config)
```
Ctrl+a, then c          # Create window
Ctrl+a, then %          # Split vertically
```

## Quick Start

### Starting Tmux

```bash
# New session
tmux

# Named session (better!)
tmux new -s devops

# New session in directory
tmux new -s myapp -c ~/projects/myapp
```

### Basic Commands

**All commands start with `Ctrl+a`** (our prefix)

```
Ctrl+a c        # Create new window
Ctrl+a |        # Split pane vertically (custom)
Ctrl+a -        # Split pane horizontally (custom)
Ctrl+a n        # Next window
Ctrl+a p        # Previous window
Ctrl+a d        # Detach from session
Ctrl+a [        # Scroll mode (press q to exit)
```

### Detach & Attach

```bash
# In tmux, press:
Ctrl+a d                    # Detach

# Outside tmux:
tmux ls                     # List sessions
tmux attach -t devops       # Reattach to "devops"
tmux a                      # Reattach to last session
```

## Pane Management

### Creating Panes (Our Custom Config)

```
Ctrl+a |        # Split vertically
Ctrl+a -        # Split horizontally
```

### Navigating Panes

```
Ctrl+a h/j/k/l          # Vim-style navigation
Ctrl+a arrow keys       # Arrow key navigation
Alt+arrow               # Navigate without prefix
```

### Resizing Panes

```
Ctrl+a H        # Resize left
Ctrl+a J        # Resize down
Ctrl+a K        # Resize up
Ctrl+a L        # Resize right
```

### Closing Panes

```
Ctrl+a x        # Kill pane (no confirmation in our config)
exit            # Or just type exit
Ctrl+d          # Or press Ctrl+d
```

### Pane Layouts

```
Ctrl+a Space    # Cycle through layouts
```

## Window Management

### Creating Windows

```
Ctrl+a c        # New window
Ctrl+a ,        # Rename window
```

### Navigating Windows

```
Ctrl+a n                # Next window
Ctrl+a p                # Previous window
Ctrl+a 0-9              # Jump to window number
Ctrl+Left/Right         # Previous/next (no prefix needed)
```

### Closing Windows

```
Ctrl+a X        # Kill window (custom - no confirmation)
Ctrl+a &        # Kill window (with confirmation)
```

### Window List

```
Ctrl+a w        # Show window list (interactive)
```

## Session Management

### Creating Sessions

```bash
tmux new -s work        # Work session
tmux new -s personal    # Personal session
tmux new -s project     # Project session
```

### Switching Sessions

```
Ctrl+a s        # Interactive session selector
Ctrl+a (        # Previous session
Ctrl+a )        # Next session
```

### Listing & Killing

```bash
tmux ls                         # List sessions
tmux kill-session -t work       # Kill "work" session
tmux kill-server                # Kill all sessions
```

## Copy Mode (Scrolling & Copying)

### Enter Copy Mode

```
Ctrl+a [        # Enter copy mode
q               # Exit copy mode
```

### Navigation in Copy Mode

```
Up/Down         # Scroll up/down
PgUp/PgDn       # Page up/down
g               # Top of history
G               # Bottom of history
/pattern        # Search forward
?pattern        # Search backward
n               # Next match
```

### Copy Text (Vim-style in our config)

```
Ctrl+a [        # Enter copy mode
v               # Start selection
y               # Copy selection (to clipboard on macOS)
Ctrl+a ]        # Paste
```

## DevOps Workflows

### Monitoring Logs

```bash
# Create session
tmux new -s monitoring

# Split into panes
Ctrl+a |        # Vertical split
Ctrl+a -        # Horizontal split

# In each pane, tail different logs:
tail -f /var/log/nginx/access.log
tail -f /var/log/app.log
kubectl logs -f pod-name
```

### Multi-Service Development

```bash
tmux new -s microservices

# Window 0: Frontend
npm run dev

Ctrl+a c        # New window

# Window 1: Backend
python manage.py runserver

Ctrl+a c        # New window

# Window 2: Database logs
docker logs -f postgres

Ctrl+a c        # New window

# Window 3: Terminal for commands
```

### SSH Persistence

```bash
# On remote server
ssh server.com
tmux new -s work

# Work for hours...
# Connection drops!

# Reconnect
ssh server.com
tmux attach -t work
# Everything still running!
```

### Pair Programming

```bash
# Person 1 creates session:
tmux new -s pairing

# Person 2 connects to same machine and attaches:
tmux attach -t pairing

# Both see and control the same session
```

### Kubernetes Debugging

```bash
tmux new -s k8s-debug

# Pane 1: Watch pods
watch kubectl get pods

Ctrl+a |        # Split

# Pane 2: Stream logs
stern app-name

Ctrl+a -        # Split horizontally

# Pane 3: Commands
kubectl exec -it pod-name -- bash
```

**Custom binding:** `Ctrl+a K` opens kubectl get pods in new pane

### Infrastructure Deployment

```bash
tmux new -s deployment

# Window 0: Terraform
terraform apply

Ctrl+a c        # New window

# Window 1: Monitor resources
watch kubectl get all

Ctrl+a c        # New window

# Window 2: Application logs
stern app-name

Ctrl+a c        # New window

# Window 3: Metrics dashboard
k9s
```

**Custom binding:** `Ctrl+a 9` opens k9s in new window

## Our Custom Config Features

### Quick Commands

```
Ctrl+a r        # Reload tmux config
Ctrl+a K        # Quick kubectl pods view
Ctrl+a D        # Quick docker ps view
Ctrl+a 9        # Open k9s in new window
Ctrl+a T        # Open btop in new window
```

### Improved Defaults

- Mouse support enabled (click panes, scroll)
- Vim-style navigation (hjkl)
- No confirmation for kill pane/window
- Prettier status bar
- 50,000 line scrollback
- Current path preserved in new panes

## Advanced Tips

### Synchronized Panes

Run same command in all panes at once:

```
Ctrl+a S        # Toggle synchronization
# Now typing goes to all panes
# Great for running commands on multiple servers
Ctrl+a S        # Toggle off
```

### Zoom Pane

```
Ctrl+a z        # Zoom into current pane (full screen)
Ctrl+a z        # Zoom out
```

### Break Pane to Window

```
Ctrl+a !        # Move pane to its own window
```

### Join Window as Pane

```bash
# From command line:
tmux join-pane -s 2.0 -t 1.0    # Move window 2 pane 0 to window 1
```

### Resize to Fit

When sharing sessions between different screen sizes:
```
Ctrl+a d        # Detach
tmux attach -d -t session       # Detach others and attach
```

## Tmux Cheat Sheet

### Essential

| Command | Action |
|---------|--------|
| `Ctrl+a c` | New window |
| `Ctrl+a \|` | Split vertical |
| `Ctrl+a -` | Split horizontal |
| `Ctrl+a h/j/k/l` | Navigate panes |
| `Ctrl+a n/p` | Next/previous window |
| `Ctrl+a d` | Detach |
| `Ctrl+a [` | Scroll mode |
| `Ctrl+a x` | Kill pane |

### Sessions

| Command | Action |
|---------|--------|
| `tmux new -s name` | New session |
| `tmux ls` | List sessions |
| `tmux attach -t name` | Attach session |
| `tmux kill-session -t name` | Kill session |
| `Ctrl+a s` | Session selector |

### Windows

| Command | Action |
|---------|--------|
| `Ctrl+a c` | New window |
| `Ctrl+a ,` | Rename window |
| `Ctrl+a w` | List windows |
| `Ctrl+a 0-9` | Go to window # |
| `Ctrl+a &` | Kill window |

## Configuration

### Edit Config

```bash
vi ~/.tmux.conf
```

### Reload Config

```
Ctrl+a r        # In tmux
# or
tmux source-file ~/.tmux.conf
```

## Common Scenarios

### Scenario 1: Long-Running Script on Remote Server

```bash
ssh server.com
tmux new -s deployment
./deploy.sh
# Connection drops...
# Reconnect:
ssh server.com
tmux attach -t deployment
# Script still running!
```

### Scenario 2: Multiple Service Logs

```bash
tmux new -s logs
# Split into 4 panes:
Ctrl+a |
Ctrl+a -
Ctrl+a h
Ctrl+a -

# In each pane, different log:
tail -f api.log
tail -f worker.log
tail -f database.log
tail -f nginx.log
```

### Scenario 3: Development Environment

```bash
tmux new -s dev -c ~/projects/myapp

# Window 0: Editor
vim src/main.py

Ctrl+a c        # Window 1: Server
python app.py

Ctrl+a c        # Window 2: Tests
pytest --watch

Ctrl+a c        # Window 3: Git/commands
git status
```

### Scenario 4: SSH to Multiple Servers

```bash
tmux new -s servers
ssh server1.com

Ctrl+a |
ssh server2.com

Ctrl+a -
ssh server3.com

# Now use synchronized panes:
Ctrl+a S
# Run same commands on all servers!
```

## Troubleshooting

### Colors Look Wrong

```bash
# Add to .zshrc or .bashrc:
export TERM=screen-256color
```

### Copy/Paste Not Working

On macOS, ensure `pbcopy` is working:
```bash
echo "test" | pbcopy
```

### Tmux Not Found

```bash
brew install tmux
```

### Session Not Persisting After Reboot

Tmux sessions don't survive reboots. Use tmux-resurrect plugin for that.

### Can't Scroll

```
Ctrl+a [        # Enter copy mode
# Then use mouse or arrow keys
q               # Exit
```

## Next Steps

### Week 1: Basics
- Create sessions with names
- Split panes (|, -)
- Navigate panes (hjkl)
- Detach and reattach

### Week 2: Workflows
- Multiple windows per session
- Copy mode for scrolling
- Session per project
- Use synchronized panes

### Week 3: Advanced
- Customize your config
- Learn layouts
- Use zoom pane
- Integrate with vim

### Plugins (Optional)

Install TPM (Tmux Plugin Manager):
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Popular plugins:
- `tmux-resurrect` - Save/restore sessions
- `tmux-continuum` - Auto-save sessions
- `tmux-yank` - Better copy/paste

## Resources

**Built-in Help:**
```
Ctrl+a ?        # Show all keybindings
```

**Man Page:**
```bash
man tmux
```

**Online:**
- https://tmuxcheatsheet.com
- https://github.com/tmux/tmux/wiki

**Practice:**
Just use it! Create a tmux session for each project. Within a week it becomes natural.

---

**Pro Tip:** Name your sessions meaningfully (`tmux new -s project-name`) and never lose your work to SSH disconnects again. Tmux + Vim over SSH is a powerful combination that works on any server, anywhere.
