function yellow_color
    printf "\033[0m\033[1m\033[38;2;192;103;9m"
end

function red_color
    printf "\033[0m\033[1m\033[38;2;226;78;78m"
end

function reset_color
    printf "\033[0m"
end

function fish_prompt --description 'Write out the prompt'
    set -g __promptstatus $pipestatus

    echo -n -s (yellow_color) "$USER" (red_color) @ (yellow_color) (prompt_hostname): ' ' \
    (red_color) (prompt_pwd) (yellow_color) (fish_vcs_prompt) \n \
    (red_color) "%: " (reset_color)
end

function fish_right_prompt
    echo -n (yellow_color) "[$__promptstatus]" (reset_color)

    set -eg __promptstatus
end
