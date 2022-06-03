all: sync

macos_defaults:
	echo "Setting up MacOS defaults..."
	defaults write com.apple.screencapture type jpg
	defaults write com.apple.screencapture show-thumbnail -bool false
	defaults write com.apple.screencapture location ~/Pictures/Screenshots
	defaults write com.apple.finder ShowPathbar -bool true
	defaults write com.apple.finder ShowStatusBar -bool true
	chflags nohidden ~/Library

sync:
	[ -d ~/.config/nvim ] || ln -s $(PWD)/nvim ~/.config/nvim
	[ -f ~/.gitconfig ] || ln -s $(PWD)/git/.gitconfig ~/.gitconfig
	[ -f ~/.zshrc ] || ln -s $(PWD)/zsh/.zshrc ~/.zshrc

clean:
	rm -rf ~/.config/nvim 
	rm -f ~/.gitconfig
	rm -f ~/.zshrc

.PHONY: all clean sync 