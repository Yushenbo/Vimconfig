syntax on
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
set ls=2 " 始终显示状态行
set wildmenu "命令行补全以增强模式运行"
set shiftwidth=4
set iskeyword+=_,$,@,%,#,-
set showcmd
set autoindent
set smartindent
set autoread
set list
set listchars=tab:>-
set ts=4
set expandtab

set nobackup
set noswapfile

set foldmethod=marker

set clipboard+=unnamed

filetype plugin indent on
filetype plugin on
set ofu=syntaxcomplete#Complete

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

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
    set nobomb " 不使用 Unicode 签名
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
" 获取当前目录
func! GetPWD()
    return substitute(getcwd(), "", "", "g")
endf
" 全选
func! SelectAll()
    let s:current = line('.')
    exe "norm gg" . (&slm == "" ? "VG" : "gH\<C-O>G")
endfunc
"函数后面加上！是防止vimrc文件重新载入时报错
"实现光标位置自动交换:) -->  ):
function! Swap()
    if getline('.')[col('.') - 1=~ ")"
        return "\<ESC>la:"
    else
        return ":"
    endif
endf
"------------------------------------------------------------------------------------
"SwitchToBuf()实现它在所有标签页的窗口中查找指定的文件名，如果找到这样一个窗口，
"就跳到此窗口中；否则，它新建一个标签页来打开vimrc文件
"上面自动编辑.vimrc文件用到的函数
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
" 定义函数SetTitle，自动插入文件头
"=======================================================================
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.py exec ":call SetTitle()"
func SetTitle()
    if &filetype == 'sh'
        call setline(1,"\#########################################################################")
        call append(line("."), "\# File Name: ".expand("%"))
        call append(line(".")+1, "\# Author: Nichol.Shen")
        call append(line(".")+2, "\# mail: nichol_shen@yahoo.com")
        call append(line(".")+3, "\# Created Time: ".strftime("%c"))
        call append(line(".")+4, "\#########################################################################")
        call append(line(".")+5, "\#!/bin/bash")
        call append(line(".")+6, "")
    elseif &filetype == 'python'
        call setline(1,"\#########################################################################")
        call append(line("."), "\# File Name: ".expand("%"))
        call append(line(".")+1, "\# Author: Nichol.Shen")
        call append(line(".")+2, "\# mail: nichol_shen@yahoo.com")
        call append(line(".")+3, "\#########################################################################")
        call append(line(".")+4, "\#!/usr/bin/python")
        call append(line(".")+5, "")
    else
        call setline(1, "/*************************************************************************")
        call append(line("."), "    > File Name: ".expand("%"))
        call append(line(".")+1, "    > Author: Nichol.Shen")
        call append(line(".")+2, "    > Mail: nichol_shen@yahoo.com")
        call append(line(".")+3, "    > Created Time: ".strftime("%c"))
        call append(line(".")+4, " ************************************************************************/")
        call append(line(".")+5, "")
    endif
    if &filetype == 'cpp'
        call append(line(".")+6, "#include<iostream>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "")
    endif
    if &filetype == 'c'
        call append(line(".")+6, "#include<stdio.h>")
        call append(line(".")+7, "")
    endif
    "新建文件后，自动定位到文件末尾
    autocmd BufNewFile * normal G
endfunc
"---------------------------------------------------
filetype plugin indent on     " required!
let tags_file=findfile("tags", ".;")
if !empty(tags_file) && filereadable(tags_file)
    let tags_cmd="set tags=".tags_file
    exe tags_cmd
endif

autocmd! bufwritepost _vimrc source $VIM/_vimrc

