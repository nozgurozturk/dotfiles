autoload -Uz compinit && compinit

# History
setopt hist_ignore_all_dups             # ignore duplicate entries
setopt hist_save_no_dups                # don't save duplicates
setopt hist_ignore_space                # ignore commands that start with space
setopt share_history                    # share command history data between parallel sessions
setopt hist_verify

# Path
export XDG_CONFIG_HOME=$HOME/.config

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export LANG=en_US.UTF-8

export EDITOR=nvim
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Plugins
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"
source <(fzf --zsh)
source <(kubectl completion zsh)

# Globals:
export FZF_DEFAULT_OPTS="
--height 90% 
--layout reverse-list
--no-scrollbar
"
# OPTION-C shortcut to change directory: exclude folders
export FZF_ALT_C_OPTS="
--walker-skip .git,node_modules,target,Library,Applications,Pictures,Music,.local,.cache,.Trash"
# CTRL-T shortcut to search files: exclude folders, preview with bat
export FZF_CTRL_T_OPTS="
--walker-skip .git,node_modules,target,Library,Applications,Pictures,Music,.local,.cache,.Trash
--preview 'bat -n --color=always {}'"
# CTRL-R shortcut to search command history: CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--color header:bold
--header 'Press CTRL-Y to copy command into clipboard'"
export FZF_CTRL_T_COMMAND=$EDITOR

# JAVASCRIPT
export PATH="$HOME/.deno/bin:$PATH"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# GO
export GOPATH=$HOME/go
export GOPRIVATE=github.com/VanMoof/*
export PATH="$HOME/go/bin:$PATH"

# RUST
export PATH="$HOME/.cargo/bin:$PATH"

# TERRAFORM
alias tf='terraform'
alias tfa='terraform apply'
alias tfa!='terraform apply -auto-approve'
alias tfc='terraform console'
alias tfd='terraform destroy'
alias 'tfd!'='terraform destroy -auto-approve'
alias tff='terraform fmt'
alias tffr='terraform fmt -recursive'
alias tfi='terraform init'
alias tfiu='terraform init -upgrade'
alias tfo='terraform output'
alias tfp='terraform plan'
alias tfv='terraform validate'
alias tfs='terraform state'
alias tft='terraform test'
alias tfsh='terraform show'
alias tfw='terraform workspace select'

# CUSTOM ALIASES
alias ls="ls -l --color"
alias lsa="ls -A -l --color"
alias nvi=$EDITOR
alias v=$EDITOR
alias cddev="cd ~/Development"
alias kctl="kubectl"
alias kctx="kubectx"
alias awsume=". awsume"

bindkey -s ^p "tmuxs\n"
bindkey -s ^f "tmuxw\n"
bindkey -s ^k "tmuxp\n"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Prompter
eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Automatically load .env file on directory change
load_dotenv() {
  if [[ -f .env ]]; then
    # `set -a` exports all subsequently defined variables
    set -a
    source .env
    set +a
  fi
}

# Add the function to the `chpwd` hook, which runs on `cd`
if [[ -z "${chpwd_functions[(r)load_dotenv]}" ]]; then
  chpwd_functions+=("load_dotenv")
fi

# Load .env for the initial shell session
load_dotenv
