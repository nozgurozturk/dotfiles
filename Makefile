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
	[ -f ~/.git-commit-template ] || ln -s $(PWD)/git/.git-commit-template ~/.git-commit-template

	[ -d ~/.config/nvim ] || ln -s $(PWD)/nvim ~/.config/nvim

	[ -d ~/.config/fish/functions ] || ln -s $(PWD)/fish/functions  ~/.config/fish/functions
	[ -f ~/.config/fish/config.fish ] || ln -s $(PWD)/fish/config.fish  ~/.config/fish/config.fish

	mkdir -p ~/.config/alacritty
	[ -f ~/.config/alacritty/alacritty.yml ] || ln -s $(PWD)/alacritty.yml  ~/.config/alacritty/alacritty.yml

	mkdir -p ~/.tmux/
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmux/tmux.conf ~/.tmux.conf
	[ -f ~/.tmux/tmux-cht-commands ] || ln -s $(PWD)/tmux/tmux-cht-commands ~/.tmux/tmux-cht-commands
	[ -f ~/.tmux/tmux-cht-languages ] || ln -s $(PWD)/tmux/tmux-cht-languages ~/.tmux/tmux-cht-languages

clean:
	rm -f ~/.config/alacritty/alacritty.yml
	rm -f ~/.config/fish/config.fish
	rm -rf ~/.config/fish/functions
	rm -rf ~/.config/nvim
	rm -f ~/.gitconfig
	rm -f ~/.git-commit-template
	rm -rf ~/.tmux
	rm -f ~/.tmux.conf

.PHONY: all clean link
