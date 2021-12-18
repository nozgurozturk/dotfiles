all: sync

sync:
	[ -d ~/.config/nvim ] || ln -s $(PWD)/nvim ~/.config/nvim
	[ -f ~/.gitconfig ] || ln -s $(PWD)/git/.gitconfig ~/.gitconfig
	[ -f ~/.zshrc ] || ln -s $(PWD)/zsh/.zshrc ~/.zshrc

clean:
	rm -rf ~/.config/nvim 
	rm -f ~/.gitconfig
	rm -f ~/.zshrc

.PHONY: all clean sync 