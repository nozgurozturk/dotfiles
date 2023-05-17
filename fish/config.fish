if status is-interactive
    # Commands to run in interactive sessions can go here
end

function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t -- $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -f backward-delete-char history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

function fish_user_key_bindings
    bind ! bind_bang
    bind '$' bind_dollar
end

# bind Control + f to tmuxs fish command
bind \cp tmuxs
bind \cf tmuxw

set -gx GOBIN $HOME/go/bin/
set -gx EDITOR nvim
set -gx FZF_CTRL_T_COMMAND nvim

# don't show any greetings
set fish_greeting

# don't describe the command for darwin
# https://github.com/fish-shell/fish-shell/issues/6270
function __fish_describe_command; end

alias vim nvim
alias vi nvim
# Created by `pipx` on 2023-02-11 16:58:41
set PATH $PATH $HOME/.local/bin

# pnpm
set -gx PNPM_HOME "/Users/ozgurozturk/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end