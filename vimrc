" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78
"===============================================================================
"
"   Personal vimrc file.
"
"   Copyright (C) 2016 by Richard Abbenhuis
"
"   Permission is hereby granted, free of charge, to any person obtaining a
"   copy of this software and associated documentation files (the "Software"),
"   to deal in the Software without restriction, including without l> imitation
"   the rights to use, copy, modify, merge, publish, distribute, sublicense,
"   and/or sell copies of the Software, and to permit persons to whom the
"   Software is furnished to do so, subject to the following conditions:
"
"   The above copyright notice and this permission notice shall be included in
"   all copies or substantial portions of the Software.
"
"   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
"   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
"   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
"   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
"   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
"   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
"   DEALINGS IN THE SOFTWARE.
"
"   Description:
"
"   The vimrc file contains my personal runtime configuration settings
"   to initialize Vim when it starts.
"
"   Revisions:
"   2017-09-11  R. Abbenhuis    Created vimrc
"
"===============================================================================
" }

" Environment {
    " Identify platform {
        silent function! IsLinux()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction

        silent function! IsWindows()
            return (has('win16') || has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible    " Must be the first line

        if (IsWindows())
            set shell=powershell.exe
            set shellcmdflag=-command
        elseif (IsLinux())
            set shell=/bin/bash
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if (IsWindows())
            set runtimepath=$HOME/.vim
            set runtimepath+=$VIM/vimfiles
            set runtimepath+=$VIMRUNTIME
            set runtimepath+=$VIM/vimfiles/after
            set runtimepath+=$HOME/.vim/after

            if has("multi_byte")
                set termencoding=utf-8
                set encoding=utf-8
                setglobal fileencoding=utf-8
                set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
            endif
        endif
    " }
" }

" Functions {
    " Initialize directories {
        function! InitializeDirectories()
            let parent = $HOME
            let prefix = 'vim'
            let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

            if has('persistent_undo')
                let dir_list['undo'] = 'undodir'
            endif

            let common_dir = parent . '/.vim/' . prefix

            for [dirname, settingname] in items(dir_list)
                let directory = common_dir . dirname . '/'

                if exists("*mkdir")
                    if !isdirectory(directory)
                        call mkdir(directory)
                    endif
                endif

                if !isdirectory(directory)
                    echo "Warning: Unable to create backup directory: " . directory
                    echo "Try: mkdir -p " . directory
                else
                    let directory = substitute(directory, " ", "\\\\ ", "g")
                    exec "set " . settingname . "=" . directory
                endif
            endfor
        endfunction
        call InitializeDirectories()
    " }
" }
