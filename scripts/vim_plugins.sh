#!/bin/sh

plugin()
{
    cd "$HOME/.config/nvim/pack/bundle/start" || exit 1
    folder=$(echo "$1" | rev | cut -d"/" -f1 | rev | cut -d"." -f1)
    if [ -d "$folder" ]; then
        cd "$folder" || exit 77
        git pull
    else
        git clone "$1" "$folder"
    fi
}


plugin "https://github.com/Arkham/vim-tango.git"
plugin "https://github.com/cespare/vim-toml.git"
plugin "https://github.com/dag/vim-fish.git"
plugin "https://github.com/dense-analysis/ale.git"
plugin "https://github.com/editorconfig/editorconfig-vim.git"
plugin "https://github.com/godlygeek/tabular"
plugin "https://github.com/itchyny/lightline.vim"
plugin "https://github.com/junegunn/fzf.vim"
plugin "https://github.com/racer-rust/vim-racer.git"
plugin "https://github.com/Shougo/deoplete.nvim.git"
