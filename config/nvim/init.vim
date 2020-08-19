" set shell to avoid problems with FiSH
let $SHELL = '/bin/bash'

" line numbering
set number relativenumber

set encoding=utf-8
set fileencoding=utf-8

syntax on
filetype indent plugin on
set nowrap
map - /

set tabstop=4
set shiftwidth=4
set expandtab
set nolist
set nohlsearch
set listchars=tab:→\ ,space:·
set undofile
set undodir=~/.local/share/nvim/undo

set ignorecase
set smartcase

nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>

let mapleader = " "
nnoremap <leader><leader> :up<CR><c-^>
nnoremap <leader>d :ALEGoToDefinition<cr>

nmap <c-s> :up<CR>
imap <c-s> <Esc>:up<CR>

inoremap jj <Esc>

nnoremap j gj
nnoremap k gk

nnoremap ay "+y
vnoremap ay "+y
nnoremap aY "+Y
vnoremap aY "+Y
nnoremap ayy "+yy
vnoremap ayy "+yy
nnoremap ap "+p
nnoremap ad "+d
vnoremap ad "+d
nnoremap add "+dd
vnoremap add "+dd

nmap <leader>c :Commentary<CR>
vmap <leader>c :Commentary<CR>

set scrolloff=5

" remove trailing whitespaces on save
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" let g:fzf_files_options = '--preview "(pygmentize {} || cat {}) 2> /dev/null | head -'.&lines.'"'
let $FZF_DEFAULT_COMMAND = 'fd --type f --exclude target --exclude Cargo.lock --exclude __pycache__'
nnoremap <leader>b :up<cr>:Buffers<cr>
nnoremap <leader>f :up<cr>:Files<cr>
nnoremap <leader>g :Rg<cr>

" ALE
let g:ale_fixers = {
      \   'rust': ['rustfmt'],
      \}

let g:ale_linters = {
      \'python': ['flake8'],
      \'rust': ['rls'],
      \}

let g:ale_fix_on_save = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_rust_cargo_use_clippy = 1
let g:ale_set_highlights = 0

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#custom#option = {'rust': ['racer']}
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" colours
let base16colorspace=256
colorscheme $BASE16_THEME
let g:lightline = {}
let g:lightline.colorscheme = $BASE16_THEME_
