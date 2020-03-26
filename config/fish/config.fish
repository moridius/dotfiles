set -x EDITOR /usr/bin/nvim
set -x VISUAL /usr/bin/nvim

functions --copy cd __fish_cd
function cd
    if [ "$argv[1]" = "" ]
       set dir (fd -t d | fzf)
    else
        set dir "$argv[1]"
    end

    if [ "$dir" != "" ]
        __fish_cd $dir && pwd > /tmp/last_cd
    end
end

function cl
    cd $argv[1] && ls
end

function last_cd
    __fish_cd (cat /tmp/last_cd)
end

function fish_greeting
end

function fish_prompt
end

function fish_mode_prompt
    set last_status $status
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
        switch $fish_bind_mode
            case default
                set mode_indicator " N "
                set color_a "\e[0m\e[38;5;8m\e[48;5;4m\e[1m"
                set color_b "\e[0m\e[38;5;7m\e[48;5;237m"
                set color_c "\e[0m\e[38;5;7m\e[48;5;235m"
                set color_d "\e[0m\e[38;5;235m"
            case insert
                set mode_indicator " I "
                set color_a "\e[0m\e[38;5;8m\e[48;5;2m\e[1m"
                set color_b "\e[0m\e[38;5;7m\e[48;5;237m"
                set color_c "\e[0m\e[38;5;7m\e[48;5;235m"
                set color_d "\e[0m\e[38;5;235m"
            case replace_one
                set mode_indicator " R "
                set color_a "\e[0m\e[38;5;8m\e[48;5;16m\e[1m"
                set color_b "\e[0m\e[38;5;7m\e[48;5;237m"
                set color_c "\e[0m\e[38;5;7m\e[48;5;235m"
                set color_d "\e[0m\e[38;5;235m"
            case visual
                set mode_indicator " V "
                set color_a "\e[0m\e[38;5;8m\e[48;5;16m\e[1m"
                set color_b "\e[0m\e[38;5;7m\e[48;5;237m"
                set color_c "\e[0m\e[38;5;7m\e[48;5;235m"
                set color_d "\e[0m\e[38;5;235m"
        end
    end

    echo -e "$color_a$mode_indicator"
    if [ "$last_status" != "0" ]
        set_color --background ff0000 f4fce2
        echo -n " $last_status "
    end
    echo -e -n "$color_b $USER "
    echo -e -n "$color_c "
    echo -n (pwd | sed "s!/home/$USER!~!g" | sed -E "s!/(.).*/!/\1/!g")
    echo -n " "
    echo -e -n "$color_d┃ "
    echo -e "\e[0m"

    if [ $CMD_DURATION -gt 2000 ]
        echo -ne '\007'
    end
end

function custom_vi_bindings
    fish_vi_key_bindings
    bind -M insert -m default jj backward-char force-repaint
    #bind -M insert -m default kk backward-char force-repaint
end
set -g fish_key_bindings custom_vi_bindings

function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end

function fzf_search
    set p (fzf)
    if [ $status = 0 ]
        if not string match "* " (commandline)
            commandline -a " "
        end
        commandline -a $p
    end
end

bind -M insert \cf fzf_search

source ~/scripts/ssh-agent.fish 2>/dev/null
source ~/.config/fish/config.local 2>/dev/null

# colours
set -gx BASE16_THEME base16-3024
if status --is-interactive
    set -gx BASE16_THEME_ (echo "$BASE16_THEME" | tr '-' '_')
    eval sh "$HOME/scripts/base16-shell/scripts/$BASE16_THEME.sh"
end
