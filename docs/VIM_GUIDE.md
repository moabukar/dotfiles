# Vim Beginner's Guide for DevOps Engineers

A practical guide to get you productive with Vim quickly.

## Why Vim?

- Available on every Linux server
- Fast editing once you learn it
- Works over SSH with no GUI
- Powerful text manipulation
- Small resource footprint

## The Basics

### Vim Modes

Vim has different modes. This is the #1 thing to understand:

**Normal Mode** (default)
- Navigate and manipulate text
- Press `Esc` to get here from any mode

**Insert Mode**
- Actually type text
- Press `i` to enter from normal mode

**Visual Mode**
- Select text
- Press `v` to enter from normal mode

**Command Mode**
- Run commands (save, quit, search/replace)
- Press `:` to enter from normal mode

## Your First 5 Minutes

### Opening Files

```bash
vim filename.txt          # Open or create file
vim +10 filename.txt      # Open at line 10
vim file1 file2 file3     # Open multiple files
```

### Quitting Vim (Most Important!)

```
:q          # Quit (if no changes)
:q!         # Quit without saving (force)
:w          # Save (write)
:wq         # Save and quit
:x          # Save and quit (shorter)
```

**In our config:** Press `Space + w` to save, `Space + q` to quit

### Insert Mode

```
i           # Insert before cursor
a           # Insert after cursor
I           # Insert at start of line
A           # Insert at end of line
o           # Insert new line below
O           # Insert new line above

Esc         # Back to normal mode
```

## Navigation (Normal Mode)

### Basic Movement

```
h           # Left
j           # Down
k           # Up
l           # Right
```

Or just use arrow keys (enabled in our config).

### Faster Movement

```
w           # Next word
b           # Back word
e           # End of word

0           # Start of line
^           # First non-blank character
$           # End of line

gg          # Top of file
G           # Bottom of file
:42         # Go to line 42

Ctrl+d      # Page down
Ctrl+u      # Page up
```

### Search

```
/pattern    # Search forward
?pattern    # Search backward
n           # Next match
N           # Previous match

*           # Search for word under cursor
```

**In our config:** `Space + /` clears search highlighting

## Editing (Normal Mode)

### Delete

```
x           # Delete character
dw          # Delete word
dd          # Delete line
D           # Delete to end of line

d$          # Delete to end of line
d^          # Delete to start of line
dG          # Delete to end of file
```

### Change

```
cw          # Change word (delete and enter insert mode)
cc          # Change line
C           # Change to end of line
ciw         # Change inner word (cursor anywhere in word)
ci"         # Change inside quotes
ci{         # Change inside braces
```

### Copy & Paste

```
yy          # Copy (yank) line
yw          # Copy word
y$          # Copy to end of line

p           # Paste after cursor
P           # Paste before cursor

3yy         # Copy 3 lines
```

**In our config:**
- `Space + y` copies to system clipboard
- `Space + p` pastes from system clipboard

### Undo & Redo

```
u           # Undo
Ctrl+r      # Redo
.           # Repeat last command
```

## Visual Mode

```
v           # Visual mode (character)
V           # Visual line mode
Ctrl+v      # Visual block mode

# Then use movement keys to select
# Then perform action:

y           # Copy selection
d           # Delete selection
c           # Change selection
>           # Indent
<           # Dedent
```

**In our config:** Indent/dedent stays in visual mode

## Searching & Replacing

### Find

```
/kubernetes         # Search forward
?kubernetes         # Search backward
n                   # Next occurrence
N                   # Previous occurrence
```

### Replace

```
:s/old/new/         # Replace first on line
:s/old/new/g        # Replace all on line
:%s/old/new/g       # Replace all in file
:%s/old/new/gc      # Replace all with confirmation

# Examples:
:%s/http/https/g                    # Change http to https everywhere
:%s/production/staging/gc           # With confirmation
:10,20s/foo/bar/g                   # Lines 10-20 only
```

## Working with Multiple Files

### Buffers

```
:e file.txt         # Edit file
:bnext              # Next buffer
:bprev              # Previous buffer
:ls                 # List buffers
:b 3                # Switch to buffer 3
:bd                 # Delete (close) buffer
```

**In our config:**
- `Space + bn` - next buffer
- `Space + bp` - previous buffer
- `Space + bd` - close buffer

### Split Windows

```
:split file.txt     # Horizontal split
:vsplit file.txt    # Vertical split

Ctrl+w h/j/k/l      # Navigate splits
Ctrl+w =            # Equal size
Ctrl+w |            # Maximize width
Ctrl+w _            # Maximize height
Ctrl+w q            # Close split
```

**In our config:**
- `Ctrl+h/j/k/l` navigates splits
- `|` creates vertical split
- `-` creates horizontal split
- `Space + +/-` resizes splits

### Tabs

```
:tabnew file.txt    # New tab
:tabnext            # Next tab (or gt)
:tabprev            # Previous tab (or gT)
:tabclose           # Close tab
```

## DevOps-Specific Tips

### Editing Kubernetes YAML

```yaml
# Jump to specific resource
/kind: Deployment

# Change namespace everywhere
:%s/default/production/g

# Comment multiple lines
Ctrl+v              # Visual block mode
j j j j             # Select lines
I                   # Insert at start
#                   # Type comment char
Esc                 # Apply to all lines
```

### Editing Terraform

```hcl
# Find all variable references
/var.

# Change resource name
:%s/old_name/new_name/gc

# Format file (if terraform installed)
:!terraform fmt %
```

### Editing Shell Scripts

```bash
# Add shebang to start
gg                  # Go to top
O                   # Insert line above
#!/bin/bash         # Type shebang
Esc

# Check syntax
:!shellcheck %

# Run script
:!bash %
```

### Editing JSON/YAML

**In our config, we added commands:**

```
:FormatJSON         # Pretty print JSON
:FormatYAML         # Pretty print YAML
:TrimWhitespace     # Remove trailing spaces
```

## Practical Workflows

### Quick Edit Remote Config

```bash
ssh server
vim /etc/nginx/nginx.conf

# Make changes
:w                  # Save
:q                  # Quit
```

### Edit Multiple Files

```bash
vim *.yaml          # Open all YAML files

# Edit first file
:bnext              # Move to next
# Edit second file
:bnext              # Move to next
# etc.

:wall               # Write all buffers
:qall               # Quit all
```

### Compare Two Files

```bash
vim -d file1.txt file2.txt
# or
vimdiff file1.txt file2.txt
```

### Edit File at Error Line

```bash
# From error message like "error at line 42"
vim +42 config.yaml
```

## Useful Tricks

### Macros (Record & Replay)

```
qa              # Start recording to register 'a'
# ... do some actions ...
q               # Stop recording
@a              # Replay macro
10@a            # Replay 10 times
```

Example: Comment 10 lines
```
qa              # Start recording
I#<Esc>j        # Add # at start, go down
q               # Stop
9@a             # Repeat 9 more times
```

### Marks (Bookmarks)

```
ma              # Set mark 'a' at cursor
'a              # Jump to mark 'a'
:marks          # List all marks
```

### Working Directory

```
:cd ~/projects              # Change directory
:pwd                        # Print working directory
:e .                        # File browser
```

### External Commands

```
:!ls                        # Run shell command
:!kubectl get pods          # Run kubectl
:read !date                 # Insert command output
```

## Our Custom Config Shortcuts

These are configured in our `.vimrc`:

```
Space + w       # Save
Space + q       # Quit
Space + x       # Save and quit
Space + /       # Clear search highlighting

Space + y       # Copy to clipboard
Space + p       # Paste from clipboard

Space + ev      # Edit vimrc
Space + sv      # Reload vimrc

Space + bn      # Next buffer
Space + bp      # Previous buffer
Space + bd      # Close buffer

Ctrl + h/j/k/l  # Navigate splits
Space + +/-     # Resize splits
```

## Common Mistakes

### Stuck in Insert Mode
**Solution:** Press `Esc`

### Accidental Commands
```
:q!             # Force quit without saving
```

### Can't Save (Permission Denied)
```
:w !sudo tee %  # Save with sudo
```

### Accidentally Deleted Text
```
u               # Undo
```

### Screen Looks Weird
```
Ctrl+L          # Redraw screen
```

## Learning Path

### Week 1: Survival
- Open, edit, save, quit
- Basic navigation (hjkl, gg, G)
- Insert mode (i, a, o)
- Delete (dd, dw, x)
- Undo (u)

### Week 2: Productivity
- Visual mode (v, V)
- Copy/paste (yy, p)
- Search (/, n, N)
- Split windows (:split, :vsplit)

### Week 3: Mastery
- Replace (:%s/old/new/g)
- Macros (qa, @a)
- Marks (ma, 'a)
- Multiple files (:e, :bnext)

### Month 2+: Expert
- Custom commands
- Vim scripting
- Plugin exploration
- Advanced text objects

## Resources

**Interactive Tutorial:**
```bash
vimtutor        # Built-in 30-minute tutorial
```

**Practice:**
- vim-adventures.com - Game to learn vim
- openvim.com - Interactive tutorial

**Reference:**
- `:help` - Built-in help
- `:help motion` - Movement commands
- `:help editing` - Editing commands

**Cheat Sheet:**
```bash
curl -s https://vim.rtorr.com/
```

## Pro Tips

1. **Stay in Normal Mode**
   - Make your edits in insert mode, then `Esc` immediately
   - Normal mode is "home base"

2. **Learn One Thing at a Time**
   - Don't try to learn everything at once
   - Add one new command per day

3. **Use Counts**
   - `5dd` deletes 5 lines
   - `10w` moves 10 words forward
   - `3yy` copies 3 lines

4. **Use `.` (Dot) to Repeat**
   - Make a change, then use `.` to repeat it
   - Powerful for repetitive edits

5. **Learn Text Objects**
   - `ciw` - change inner word
   - `di"` - delete inside quotes
   - `ca{` - change around braces

6. **Make Vim Yours**
   - Edit `.vimrc` to add shortcuts
   - Build muscle memory for your workflow
   - Don't copy others' configs blindly

## When NOT to Use Vim

- Large files (>100MB) - use `less` or specialized tools
- Binary files - use hexeditors
- Complex IDE needs - use VS Code/Cursor for big projects
- Markdown previews - use dedicated editors

But for quick edits, config files, and SSH sessions? Vim is unbeatable.

---

**Remember:** Everyone struggles with Vim at first. Stick with it for 2 weeks and it becomes natural. After a month, you'll be faster than any GUI editor.
