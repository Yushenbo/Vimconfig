syntax on
set noscrollbind
set linebreak
set nocompatible
set backspace=indent,eol,start
set textwidth=80
set wrap
set tabpagemax=9
set showtabline=2
set number
set ruler

set ch=2
set ls=2
set wildmenu
set hlsearch  " Highlight search things
set magic     " Set magic on, for regular expressions
set showmatch " Show matching bracets when text indicator is over them
set mat=2     " How many tenths of a second to blink
set tabstop=4
set noincsearch
set noscrollbind
set linebreak
set nocompatible
set textwidth=80
set wrap
set tabpagemax=9
set showtabline=2
set number
set ruler
set ch=2
set ls=2
set wildmenu
set ts=4
set expandtab
set shiftwidth=4
set iskeyword+=_,$,@,%,#,-
set showcmd
set autoindent
set smartindent
set autoread
set list
set listchars=tab:>-

set nobackup
set noswapfile

set foldmethod=marker

set clipboard+=unnamed

set nocscopeverbose " Fobbiden duplcated add cscope.out database

let mapleader = ","
let maplocalleader = ","
map <silent> <leader>e :e $VIM/.vimrc<cr>

autocmd! bufwritepost _vimrc source $VIM/_vimrc

" =====================================================================
" Multi_language setting default encoding UTF
" =====================================================================

if has("multi_byte")
    set encoding=utf-8
    if has('win32')
        language chinese
        let &termencoding=&encoding
    endif
    set nobomb " ... Unicode ..
    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif
else
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

" ===========================================
" AutoCmd
" ===========================================
if has("autocmd")
    filetype plugin indent on
    func! AutoClose()
        :inoremap ( ()<ESC>i
        :inoremap " ""<ESC>i
        :inoremap ' ''<ESC>i
        :inoremap { {}<ESC>i
        :inoremap [ []<ESC>i
        :inoremap ) <c-r>=ClosePair(')')<CR>
        :inoremap } <c-r>=ClosePair('}')<CR>
        :inoremap ] <c-r>=ClosePair(']')<CR>
    endf
    func! ClosePair(char)
        if getline('.')[col('.') - 1] == a:char
            return "\<Right>"
        else
            return a:char
        endif
    endf
    augroup vimrcEx
        au!
        autocmd FileType text setlocal textwidth=80
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
    augroup END
    " Auto close quotation marks for PHP, Javascript, etc, file
    au FileType php,javascript,c,cpp exe AutoClose()
endif
" ==================
" script's functions
"===================
func! GetPWD()
    return substitute(getcwd(), "", "", "g")
endf
" ..
func! SelectAll()
    let s:current = line('.')
    exe "norm gg" . (&slm == "" ? "VG" : "gH\<C-O>G")
endfunc
"..........vimrc.........
"..........:) -->  ):
function! Swap()
    if getline('.')[col('.') - 1=~ ")"
        return "\<ESC>la:"
    else
        return ":"
    endif
endf
"------------------------------------------------------------------------------------
function! SwitchToBuf(filename)
    let bufwinnr = bufwinnr(a:filename)
    if bufwinnr != -1
        exec bufwinnr . "wincmd w"
        return
    else
        " find in each tab
        tabfirst
        let tab = 1
        while tab <= tabpagenr("$")
            let bufwinnr = bufwinnr(a:filename)
            if bufwinnr != -1
                exec "normal " . tab . "gt"
                exec bufwinnr . "wincmd w"
                return
            endif
            tabnext
            let tab = tab + 1
        endwhile
        " not exist, new tab
        exec "tabnew " . a:filename
    endif
endfunction
" =======================================================================
" SetTitle's functions
"=======================================================================
autocmd BufNewFile *.cpp,*.cc,*.[ch],*.sh,*.py,*.java exec ":call SetTitle()"
func SetTitle()
    if &filetype == 'sh'
        call setline(1,"\#########################################################################")
        call append(line("."), "\# File Name: ".expand("%"))
        call append(line(".")+1, "\# Author: Shen Bo")
        call append(line(".")+2, "\# mail: Bo.A.Shen@alcatel-sbell.com.cn")
        call append(line(".")+3, "\# Created Time: ".strftime("%c"))
        call append(line(".")+4, "\#########################################################################")
        call append(line(".")+5, "\#!/bin/bash")
        call append(line(".")+6, "")
    elseif &filetype == 'python'
        call setline(1,"\#-*- coding:utf-8 -*-")
        call append(line("."), "\#########################################################################")
        call append(line(".")+1, "\# File Name: ".expand("%"))
        call append(line(".")+2, "\# Author: Shen Bo")
        call append(line(".")+3, "\# mail: Bo.A.Shen@alcatel-sbell.com.cn")
        call append(line(".")+4, "\# Created Time: ".strftime("%c"))
        call append(line(".")+5, "\#########################################################################")
        call append(line(".")+6, "\#!usr/bin/env python")
        call append(line(".")+7, "")
    else
        call setline(1, " /*************************************************************************")
        call append(line("."), "    > File Name: ".expand("%"))
        call append(line(".")+1, "    > Author: Shen Bo")
        call append(line(".")+2, "    > mail: Bo.A.Shen@alcatel-sbell.com.cn")
        call append(line(".")+3, "    > Created Time: ".strftime("%c"))
        call append(line(".")+4, " ************************************************************************/")
        call append(line(".")+5, "")
    endif

    if &filetype == 'cpp'
        call append(line(".")+6, "#include <iostream>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "")
    endif

    if &filetype == 'c'
        call append(line(".")+6, "#include <stdio.h>")
        call append(line(".")+7, "")
    endif

    autocmd BufNewFile * normal G
endfunc
"---------------------------------------------------
filetype plugin indent on     " required!
let tags_file=findfile(".tags", ".;")
if !empty(tags_file) && filereadable(tags_file)
    let tags_cmd="set tags=".tags_file
    exe tags_cmd
endif

let cscope_file=findfile("cscope.out", ".;")
if !empty(cscope_file) && filereadable(cscope_file)
    let cs_cmd="cs add ".cscope_file
    exe cs_cmd
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
endif

if has("autocmd")
    autocmd  BUfReadPost * Tlist 
endif
