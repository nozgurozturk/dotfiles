function tmuxw
    set -l window $(find "$PWD" -mindepth 1 -maxdepth 1 -type d | fzf)
    if test -z "$window"
        return
    end

    set -l window_name (basename $window | tr . _)

    set -l session_name $(tmux display-message -p "#S")
    set -l target "$session_name:$window_name"

    if ! tmux has-session -t $target 2> /dev/null
        tmux neww -dn $window_name -c $window
    end

   tmux switch-client -t $target
end
