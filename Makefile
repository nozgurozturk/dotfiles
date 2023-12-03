all: link


generate_ssh: password = $(shell openssl rand -base64 32)
generate_ssh:
	@echo "Generating SSH key..."
	@echo ${password}
	ssh-keygen -t ed25519 -C "ozgur@nozgurozturk.com" -N ${password} -f ~/.ssh/id_ed25519
	# Append Github Host to ssh config
	[ -f ~/.ssh/config ] || echo "\nHost github.com\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_ed25519\n" >> ~/.ssh/config
	# Add SSH key to ssh-agent
	ssh-add --apple-use-keychain ~/.ssh/id_ed25519
	# Copy SSH key to clipboard
	[ -f ~/.ssh/id_ed25519.pub ] && pbcopy < ~/.ssh/id_ed25519.pub
	# Inform user
	@echo "SSH key copied to clipboard!"
	@echo "Your passphrase is added to apple keychain! In case you want to keep the password, here it is\n${password}"

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

	[ -f ~/.zshrc ] || ln -s $(PWD)/zsh/.zshrc ~/.zshrc
	[ -f ~/.zsh_profile ] || ln -s $(PWD)/zsh/.zsh_profile ~/.zsh_profile

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
	rm -f ~/.zsh_profile
	rm -rf ~/.config/nvim
	rm -f ~/.gitconfig
	rm -f ~/.git-commit-template
	rm -rf ~/.tmux
	rm -f ~/.tmux.conf
	rm -rf ~/.local/scripts

