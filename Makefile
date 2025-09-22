SHELL := /bin/bash

# Development environment
ENV_DIR := $(PWD)/env

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: install link setup-macos-preferences

.PHONY: destroy
destroy: uninstall unlink

.PHONY: install
install: install-brew install-dependencies install-tmux-plugin-manager install-zsh-plugins

.PHONY: uninstall
uninstall: uninstall-zsh-plugins uninstall-tmux-plugin-manager uninstall-dependencies uninstall-brew

.PHONY: install-brew
install-brew:
	$(call print-target)
	# Install and setup brew
	[ -d /opt/homebrew ] || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	# Enable Homebrew shellenv
	eval "$$(/opt/homebrew/bin/brew shellenv)" 
	# Disable telemetry
	brew analytics off

.PHONY: uninstall-brew
uninstall-brew:
	$(call print-target)
	# Uninstall homebrew
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
	# Remove homebrew packages
	rm -rf /opt/homebrew

.PHONY: setup-macos-preferences
setup-macos-preferences:
	$(call print-target)
	# Dock preferences
	# Autohide
	defaults write com.apple.dock "autohide" -bool true 
	# Disable delay on mouse over
	defaults write com.apple.dock "autohide-delay" -float "0"
	# Groups windows by application on mission control
	defaults write com.apple.dock expose-group-apps -bool true
	# Disable rearrange Spaces automatically
	defaults write com.apple.dock "mru-spaces" -bool false
	# Disable recents
	defaults write com.apple.dock "show-recents" -bool false
	# only show open apps on dock
	defaults write com.apple.dock static-only -bool true

	# Font
	defaults -currentHost write -g AppleFontSmoothing -int 0

	# Finder
	# Show hidden files
	defaults write com.apple.finder "AppleShowAllFiles" -bool true
	# Show path bar
	defaults write com.apple.finder "ShowPathbar" -bool true
	# Show status bar
	defaults write com.apple.finder "ShowStatusBar" -bool true
	# List view
	defaults write com.apple.finder "FXPreferredViewStyle" -string Nlsv
	# Keep folders on top
	defaults write com.apple.finder "_FXSortFoldersFirst" -bool true
	# Search scope current folder
	defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
	# Disable desktop icons
	defaults write com.apple.finder "CreateDesktop" -bool true
	# Disable drive icon on desktop
	defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool false

	# WindowManager
	defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

	# Security
	# Enable firewall
	sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

	# Screencapture 
	mkdir -p ~/Pictures/Screenshots
	defaults write com.apple.screencapture "location" -string "~/Pictures/Screenshots"

	# Show file extensions
	defaults write NSGlobalDomain "AppleShowAllExtensions" -bool true

	# Privacy
	defaults write com.apple.AdLib.plist allowApplePersonalizedAdvertising -bool false
	defaults write com.apple.AdLib.plist allowIdentifierForAdvertising -bool false
	defaults write com.apple.AdLib.plist personalizedAdsMigrated -bool false

	# NSGlobalDomain
	# disables "corrects spelling automatically"
	defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
	# key repeat rate: fast
	defaults write -g KeyRepeat -int 2
	# delay until repeat: short
	defaults write -g InitialKeyRepeat -int 15

	# Restart dock and finder to apply changes
	killall Dock && killall Finder && killall SystemUIServer

.PHONY: install-dependencies
install-dependencies:
	$(call print-target)
	# Install macOS packages via brew
	brew bundle install --file Brewfile

.PHONY: uninstall-dependencies
uninstall-dependencies:
	$(call print-target)
	brew remove --force --ignore-dependencies $$(brew list --formula)
	brew remove --cask --force --ignore-dependencies $$(brew list)

.PHONY: install-tmux-plugin-manager
install-tmux-plugin-manager:
	$(call print-target)
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

.PHONY: uninstall-tmux-plugin-manager
uninstall-tmux-plugin-manager:
	$(call print-target)
	rm -rf ~/.tmux/plugins/tpm

.PHONY: install-zsh-plugins
install-zsh-plugins:
	$(call print-target)
	# Autosuggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
	# Syntax Highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
	# Better history search
	git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh/zsh-history-substring-search

.PHONY: uninstall-zsh-plugins
uninstall-zsh-plugins:
	$(call print-target)
	rm -rf ~/.zsh/zsh-autosuggestions
	rm -rf ~/.zsh/zsh-syntax-highlighting
	rm -rf ~/.zsh/zsh-history-substring-search/

.PHONY: link
link:
	$(call print-target)
	# Link config files
	[ -L ~/.config ] || ln -svf $(ENV_DIR)/.config $(HOME)
	# Link shell config
	[ -L ~/.zshrc ] || ln -svf $(ENV_DIR)/.zshrc $(HOME)
	# Link scripts
	# TODO: this is not an optimal solution
	[ -L ~/.local/bin/tmuxp ] || ln -svf $(ENV_DIR)/.local/bin/tmuxp $(HOME)/.local/bin/tmuxp
	[ -L ~/.local/bin/tmuxf ] || ln -svf $(ENV_DIR)/.local/bin/tmuxw $(HOME)/.local/bin/tmuxw
	[ -L ~/.local/bin/tmuxs ] || ln -svf $(ENV_DIR)/.local/bin/tmuxs $(HOME)/.local/bin/tmuxs
	# Link git config
	[ -L ~/.gitconfig ] || ln -svf $(ENV_DIR)/.gitconfig $(HOME)
	# Link rg config
	[ -L ~/.ripgreprc ] || ln -svf $(ENV_DIR)/.ripgreprc $(HOME)

.PHONY: unlink
unlink:
	$(call print-target)
	# Unlink config files
	rm -rf ~/.config
	# Unlink shell config
	rm -rf ~/.zshrc
	# Unlink scripts
	rm -rf ~/.local/bin/tmuxp
	rm -rf ~/.local/bin/tmuxw
	rm -rf ~/.local/bin/tmuxs
	# Unlink git config
	rm -rf ~/.gitconfig
	# Unlink rg config
	rm -rf ~/.ripgreprc

define print-target
    @printf "Executing target: \033[36m$@\033[0m\n"
endef
