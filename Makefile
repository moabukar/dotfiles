# Do everything.
all: init link defaults brew code asdf

# Test(skip brew and code)
test: init link defaults 

# Set initial preference.
init:
	@scripts/init.sh

# Link dotfiles.
link:
	@scripts/link.sh

# Set macOS system preferences.
defaults:
	@scripts/defaults.sh

# Install macOS applications.
brew:
	@scripts/brew.sh

# update vscode extentions
codeex:
	@code --list-extensions > vscode/extensions

# Set VSCode settings.
code:
	@scripts/code.sh

# google chrome extentions list up
chromeex:
	@ls -l $${HOME}/Library/Application\ Support/Google/Chrome/Default/Extensions | awk '{print $$9}' | sed 's/^/https:\/\/chrome.google.com\/webstore\/detail\//g' | sed -e '1,2d' > chrome/extensions

# Install Languages
asdf:
	@scripts/asdf.sh