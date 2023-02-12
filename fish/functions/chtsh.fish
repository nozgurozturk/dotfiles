function chtsh

    set -l selected $(cat ~/.tmux-cht-languages ~/.tmux-cht-commands | fzf)
    if [ -z $selected ]
        exit 0
    end

   read -P 'Enter Query: ' query

    if grep -qs "$selected" ~/.tmux-cht-languages
        set -l query $(echo $query | tr ' ' '+')
        tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
    else
        tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
    end
end
