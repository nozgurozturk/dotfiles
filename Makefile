all: link

install_dependencies:
	@echo "Installing dependencies..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

setup_terminal:
	@echo "Setting up terminal..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	rm -rf ~/.tmux/plugins/tpm &&  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	rm -rf  ~/.local/share/nvim/site/pack/packer/start/packer.nvim && git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
	rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	rm -rf ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

setup_macos:
	@echo "Setting up MacOS defaults..."
	mkdir -p ~/Pictures/Screenshots

	defaults write com.apple.screencapture type jpg
	defaults write com.apple.screencapture show-thumbnail -bool false
	defaults write com.apple.screencapture location ~/Pictures/Screenshots
	defaults write com.apple.finder ShowPathbar -bool true
	defaults write com.apple.finder ShowStatusBar -bool true

	chflags nohidden ~/Library

link_config_files:
	@echo "Linking config files..."
	[ -f ~/.gitconfig ] || ln -s $(PWD)/git/.gitconfig ~/.gitconfig
	[ -f ~/.git-commit-template ] || ln -s $(PWD)/git/.git-commit-template ~/.git-commit-template

	[ -d ~/.config/nvim ] || ln -s $(PWD)/nvim ~/.config/nvim
	[ -d ~/.config/wezterm ] || ln -s $(PWD)/wezterm ~/.config/wezterm

	[ -f ~/.zshrc ] || ln -s $(PWD)/zsh/.zshrc ~/.zshrc
	[ -f ~/noo.omp.json ] || ln -s ${PWD}/omp/noo.omp.json ~/noo.omp.json

	mkdir -p ~/.tmux/
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmux/tmux.conf ~/.tmux.conf
	[ -f ~/.tmux/tmux-cht-commands ] || ln -s $(PWD)/tmux/tmux-cht-commands ~/.tmux/tmux-cht-commands
	[ -f ~/.tmux/tmux-cht-languages ] || ln -s $(PWD)/tmux/tmux-cht-languages ~/.tmux/tmux-cht-languages

	[ -d ~/.local/scripts ] || ln -s $(PWD)/bin/.local/scripts ~/.local/scripts

give_access:
	echo "Giving access to scripts..."
	find ~/.local/scripts/* -type f -exec chmod u+x {} \;

clean:
	echo "Cleaning up..."
	rm -f ~/.zshrc
	rm -f ~/noo.omp.json
	rm -rf ~/.config/nvim
	rm -rf ~/.config/wezterm
	rm -f ~/.gitconfig
	rm -f ~/.git-commit-template
	rm -rf ~/.tmux
	rm -f ~/.tmux.conf
	rm -rf ~/.local/scripts

