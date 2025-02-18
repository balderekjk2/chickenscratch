
"< ADDITIONS >"

set nocompatible  " vim defaults
set mouse=a  " mouse support, shift + clickdrag to highlight and/or copy selections
set ruler  " cursor visible at all times
set bs=indent,eol,start  " reliable backspacing
set confirm  " confirm save on exit
set visualbell  " no annoying error sounds
set t_vb=

set hlsearch  " highlight matches
colorscheme murphy  " better general colorscheme

set tabstop=4  " four-space indentation is convention
set softtabstop=4
set shiftwidth=4
set expandtab  " expand tab into spaces, four spaces per tab
set autoindent
set autoread  " refresh on outside changes
au FocusGained,BufEnter * silent! checktime"filetype plugin indent on
filetype plugin indent on
syntax on
au FileType css setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab  " different defaults for specific filetypes

"< PLUGINS >"
let data_dir = expand('~/.vim')
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent! execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
let plugins = [
\ 'Vimjas/vim-python-pep8-indent'
\]
call plug#begin(data_dir . '/plugged')
for plugin in plugins
    execute 'Plug ' . string(plugin)
endfor
call plug#end()
for plugin in plugins
    let plugin_dir = data_dir . '/plugged/' . substitute(plugin, '.*/', '', '')
    if empty(glob(plugin_dir))
        au VimEnter * silent! PlugInstall --sync | q
        break
    endif
endfor
let g:pymode_indent = 0
"</ PLUGINS >"

"let mapleader=','  " default <leader> is '\' backslash
set timeoutlen=2500  " increase time to hit consecutive keys in command

nnoremap qr q|                             " unset annoying shortcuts
nnoremap q <Nop>
nnoremap Q <Nop>
vnoremap <C-z> <Nop>
nnoremap <silent> <C-e> :Ex<CR>|           " ctrl-e for explorer
nnoremap <silent> <leader>e :Ex<CR>
nnoremap <silent> <C-t> :Tex<CR>|          " ctrl-t for tab explorer
nnoremap <silent> <leader>t :Tex<CR>
nnoremap <silent> <Esc><Left> :tabp<CR>|   " alt-left for prev tab
nnoremap <silent> <Esc><Right> :tabn<CR>|  " alt-right for next tab
nnoremap <silent> <C-o> :w!<CR>|           " ctrl-o for overwrite
inoremap <silent> <C-o> <Esc>:w!<CR>a
nnoremap <silent> <leader>o :w!<CR>
nnoremap <silent> <C-q> :q<CR>|            " ctrl-q for quit/save?
inoremap <silent> <C-q> <Esc>:q<CR>
nnoremap <silent> <leader>q :q<CR>
nnoremap <silent> <Esc>q :qa<CR>|          " alt-q for close all
inoremap <silent> <Esc>q <Esc>:qa<CR>
nnoremap <silent> <leader>Q :qa<CR>
nnoremap <C-z> u|                          " ctrl-z for undo
inoremap <C-z> <Esc>ua
nnoremap `1 :set paste mouse=<CR>a
nnoremap 2 :set nopaste mouse=a \| echo 'mouse enabled'<CR>

nnoremap y yy|                             " y for yank/copy
nnoremap J G$|                             " J for move to end of file
nnoremap K gg|                             " K for move to start of file
nnoremap j 3j|                             " j for move down 3 lines
nnoremap ' k|

function! Help()  " h for help (if mappings change, this must be updated)
    echom '------------'
    echom printf('%-26s %-26s %-26s %-26s %-26s %-26s', '^: Ctrl', 'M: Alt', '(h) Toggle help', '(M-h) See mappings', '[:h] More help', '[^c] Cancel')
    echom printf('%-26s %-26s %-26s %-26s %-26s %-26s %-26s', '[^u] half up', '[^d] half down', '[j] 3 lines down', '[k] 1 line up', '('') 3 lines up', '(J) To bottom', '(K) To top')
    echom printf('%-26s %-26s %-26s %-26s %-26s %-26s', '[i] Write', '(^z)[u] Undo', '[^r]: Redo', '(^o)[:w!] Save', '(^q)[:q] Quit/save?', '(M-q)[:qa] Quit all/save?')
    echom printf('%-53s %-53s %-53s', '(^t)[:Tex] Tab explorer', '(M-left)[:tabp] Prev tab', '(M-right)[:tabn] Next tab')
endfunction
nnoremap <silent> h :call Help()<CR>|   " h is help
nnoremap <silent> <Esc>h :echo system("echo '------------'; grep -E '^.noremap ' ~/.vimrc")<CR>
command! -nargs=* Twref echo "------------\n" . trim(system('twref ' . shellescape(<q-args>)))

function! Replace(selection, with)
    if empty(a:selection)
        return
    endif
    let replacement = a:selection[0] == '/' ? '%s/\v' . strpart(a:selection, 1) : '%s/' . a:selection
    let cmd = replacement . '/' . a:with . '/g'
    execute cmd
endfunction
nnoremap <silent> <leader>fr :call Replace(input('replace (lead with ''/'' for regex):'), input('with:'))<CR>

function! ScaleIndent(double)
    let l:lines = line('$')
    for l:lnum in range(1, l:lines)
        let l:line = getline(l:lnum)
        let l:indent = len(matchstr(l:line, '^\s\+'))
        if !a:double && l:indent == 2
            return
        else
            let l:new_indent = a:double ? l:indent * 2 : max([0, l:indent / 2])
            call setline(l:lnum, repeat(' ', l:new_indent) . substitute(l:line, '^\s*', '', ''))
        endif
    endfor
endfunction
nnoremap <silent> <Esc>= :call ScaleIndent(1)<CR>
nnoremap <silent> <Esc>- :call ScaleIndent(0)<CR>

function! ShiftWidth(bynum)
    if !empty(a:bynum) && a:bynum =~ '^[2468]$'
        execute 'set shiftwidth=' . a:bynum
        execute 'set softtabstop=' . a:bynum
    else
        echom " "
        echom "only 2, 4, 6, or 8 accepted"
    endif
endfunction
nnoremap <silent> <leader>sw :call ShiftWidth(input('shift='))<CR>

function! AdjLWS()
    let line = getline('.')
    let len_spaces = len(matchstr(line, '^\s\+'))
    if len_spaces
        let newcount = input('indents applied:')
        if !empty(newcount) && newcount =~ '^[1-6]$'
            call feedkeys(":%s/^ \\{" . len_spaces . "\\}/\\=repeat(' ', " . (&shiftwidth * newcount) . ")/\r", 'n')
        endif
    else
        call feedkeys("\<C-l>", 'n')
    endif
endfunction

nnoremap <silent> <leader>aw :call AdjLWS()<CR>

"</ ADDITIONS >"
