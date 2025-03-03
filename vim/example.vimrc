
"< ADDITIONS >"

set nocompatible
set mouse=a
set bs=indent,eol,start
set confirm

set hlsearch
colorscheme murphy

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent

syntax on
filetype plugin indent on
au FileType css,yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

set timeoutlen=1500

nnoremap <C-z> <Nop>
vnoremap <C-z> <Nop>
nnoremap <silent> <leader>t :Tex<CR>
nnoremap <silent> <leader>o :w!<CR>
inoremap <silent> <leader>q :q<CR>
nnoremap <silent> <leader>Q :qa<CR>
nnoremap `1 :set paste mouse=<CR>a
nnoremap <Esc>2 :set nopaste mouse=a nonumber nohlsearch \| echo 'mouse enabled'<CR>

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
