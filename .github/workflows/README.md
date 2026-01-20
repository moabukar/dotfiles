# GitHub Actions CI

## Test Workflow

The `test.yml` workflow runs the complete dotfiles setup on macOS runners.

### Triggers
- Push to main/master
- Pull requests
- Manual workflow dispatch

### What It Tests
1. Homebrew installation
2. Package installation (git, kubectl, terraform, helm, node, python)
3. Oh My Zsh + Powerlevel10k setup
4. Zsh plugins (syntax highlighting, autosuggestions)
5. Config file linking (.zshrc, .gitconfig, .vimrc, .tmux.conf)
6. Custom aliases and functions
7. Tool versions and functionality

**Note:** Docker Desktop is not tested as it's not available on GitHub's macOS runners by default. It will be installed via Brewfile on your local Mac.

### Running Time
Approximately 15-20 minutes (depends on GitHub runner performance)

### View Results
Check the Actions tab in your GitHub repository to see test results.

### Running Locally in Non-Interactive Mode
```bash
CI=true ./bootstrap.sh
# or
NONINTERACTIVE=true ./bootstrap.sh
```
