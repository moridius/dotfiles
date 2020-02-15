set -x EDITOR /usr/bin/nvim
set -x VISUAL /usr/bin/nvim

functions --copy cd __fish_cd
function cd
    __fish_cd $argv
    if [ $status -eq 0 ]
        pwd > /tmp/last_cd
    end
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
                set color_a afd700 185f00
                set color_b 585858 ffffff
                set color_c 303030 ffffff
                set color_d normal 303030
            case insert
                set mode_indicator " I "
                set color_a ffffff 005f5f
                set color_b 0087af f4fce2
                set color_c 005f87 f4fce2
                set color_d normal 005f87
            case replace_one
                set mode_indicator " R "
                set color_a aaff00 185f00
                set color_b aaaa00 185f00
                set color_c 303030 ffffff
                set color_d normal 303030
            case visual
                set mode_indicator " V "
                set color_a ff8700 870000
                set color_b 585858 ffffff
                set color_c 303030 ffffff
                set color_d normal 303030
        end
    end

    set_color --bold --background $color_a[1] $color_a[2]
    echo "$mode_indicator"
    if [ "$last_status" != "0" ]
        set_color --background ff0000 f4fce2
        echo -n " $last_status "
    end
    set_color --background $color_b[1] $color_b[2]
    echo -n " $USER "
    set_color --background $color_c[1] $color_c[2]
    echo -n " "
    echo -n (pwd | sed "s!/home/$USER!~!g" | sed -E "s!/(.).*/!/\1/!g")
    echo -n " "
    set_color --background $color_d[1] $color_d[2]
    echo -n "┃ "
    set_color normal

    if [ $CMD_DURATION -gt 2000 ]
        echo -ne '\007'
    end
end

function fish_prompt_old
    set last_status $status
    if [ $COLUMNS -lt 20 ]
        echo "> "
    else
        set_color 666666
        echo -n (date "+%H:%M ")
        if [ "$last_status" != "0" ]
            set_color red
            echo -n "$last_status "
        end
        set_color DDDDDD
        echo -n "$USER "
        if [ $COLUMNS -ge 50 ]
            set_color green
            echo -n (pwd | sed "s!/home/$USER!~!g" | sed -E "s!/(.).*/!/\1/!g")
            set_color normal
        else
            echo ""
        end
        echo -n "> "
        if [ $CMD_DURATION -gt 10000 ]
            echo -ne '\007'
        end
    end
end

function fish_mode_prompt_old
    # Do nothing if not in vi mode
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
        switch $fish_bind_mode
            case default
                set_color --bold --background red white
                echo 'N'
            case insert
                set_color --bold --background green white
                echo 'I'
            case replace_one
                set_color --bold --background green white
                echo 'R'
            case visual
                set_color --bold --background magenta white
                echo 'V'
        end
        set_color normal
        echo -n ' '
    end
end

function fish_right_prompt
    if [ (tput cols) -ge 50 ]
        set file "/tmp/weddingpi"
        set_color grey
        echo -n "[Pi: "
        if [ ! -f "$file" ]
            set_color red
            echo -n "?"
        else
            if grep -sq "0" "$file"
                set_color green
                echo -n "OK"
            else if grep -sq "1" "$file"
                set_color red
                echo -n "NOK"
            else
                set_color red
                echo -n "?"
            end
        end
        set_color grey
        echo -n "]"
        set_color normal
    end
end

function cl
    if [ -d $argv[1] ]
        cd $argv[1]
        ls
        return 0
    else
        echo "Directory does not exist." >&2
        return 1
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

/usr/bin/eject -i on /dev/sr0 >/dev/null 2>&1

source ~/scripts/ssh-agent.fish 2>/dev/null
source ~/.config/fish/config.local 2>/dev/null

if status is-interactive && not set -q TMUX
    exec tmux
end
