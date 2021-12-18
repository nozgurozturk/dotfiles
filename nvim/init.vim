source $HOME/.config/nvim/plugins/load.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/keys/mappings.vim

lua << END

require('plugins.nvim-cmp')
require('plugins.nvim-lsp')

END

source $HOME/.config/nvim/plugins/vim-go.vim
source $HOME/.config/nvim/plugins/nvim-lspconfig.vim
source $HOME/.config/nvim/plugins/nerdtree.vim
