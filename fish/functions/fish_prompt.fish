function fish_prompt -d "Show prompt"
    set_color yellow
    prompt_pwd | tr -d '\n'
    set_color normal
    git_status
    printf "\$"
end
