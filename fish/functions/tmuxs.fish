function tmuxs

    set -l session $(find  ~/Development/github.com/nozgurozturk ~/Development/github.com/VanMoof ~/Development/github.com/VanMoof-Playground -mindepth 1 -maxdepth 1 -type d | fzf)
    set -l session_name $(basename "$session" | tr . _)

    if ! tmux has-session -t "$session_name" 2>/dev/null
        tmux new-session -s "$session_name" -c "$session" -d
    end

    tmux switch-client -t "$session_name"
end
