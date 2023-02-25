if status is-interactive
    # vars
    set fish_greeting

    # colors
    set fish_color_user 40A4FF
    set fish_color_command cfbb07
    set fish_color_host 40A4FF
    set fish_color_error FF5250
    set fish_color_cwd 40A4FF
    set fish_color_param green

    # a few qol aliases that shouldnt majorly effect life
    alias ls="ls -A --color=auto"
    alias rm="sudo rm -r"
    alias cp="cp -r"
    alias mkdir="mkdir -p"
end