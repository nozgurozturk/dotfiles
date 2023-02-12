all: link

macos_defaults:
	echo "Setting up MacOS defaults..."
	defaults write com.apple.screencapture type jpg
	defaults write com.apple.screencapture show-thumbnail -bool false
	defaults write com.apple.screencapture location ~/Pictures/Screenshots
	defaults write com.apple.finder ShowPathbar -bool true
	defaults write com.apple.finder ShowStatusBar -bool true
	chflags nohidden ~/Library

link:
	[ -f ~/.gitconfig ] || ln -s $(PWD)/git/.gitconfig ~/.gitconfig

	[ -d ~/.config/nvim ] || ln -s $(PWD)/nvim ~/.config/nvim

	[ -d ~/.config/fish/functions ] || ln -s $(PWD)/fish/functions  ~/.config/fish/functions
	[ -f ~/.config/fish/config.fish ] || ln -s $(PWD)/fish/config.fish  ~/.config/fish/config.fish

	mkdir -p ~/.config/alacritty
	[ -f ~/.config/alacritty/alacritty.yaml ] || ln -s $(PWD)/alacritty.yaml  ~/.config/alacritty/alacritty.yaml

	mkdir -p ~/.tmux/
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmux/tmux.conf ~/.tmux.conf
	[ -f ~/.tmux-cht-commands ] || ln -s $(PWD)/tmux/tmux-cht-commands ~/.tmux-cht-commands
	[ -f ~/.tmux-cht-languages ] || ln -s $(PWD)/tmux/tmux-cht-languages ~/.tmux-cht-languages

clean:
	rm -f ~/.config/alacritty/alacritty.yaml
	rm -f ~/.config/fish/config.fish
	rm -rf ~/.config/fish/functions
	rm -rf ~/.config/nvim
	rm -f ~/.gitconfig
	rm -f ~/.tmux.conf

.PHONY: all clean link
