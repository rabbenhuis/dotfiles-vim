" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=9 foldmethod=marker
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

    " Setup Vundle support {
        filetype off

        " Set the runtime path to include Vundle and initialize
        set rtp+=~/.vim/bundle/Vundle.vim
        call vundle#begin()

        " Let Vundle manage Vundle, required
        Plugin 'VundleVim/Vundle.vim'

        " Dependency plugins
        Plugin 'MarcWeber/vim-addon-mw-utils'
        Plugin 'tomtom/tlib_vim'

        " General plugins
        Plugin 'altercation/vim-colors-solarized'
        Plugin 'scrooloose/nerdtree'
        Plugin 'rhysd/conflict-marker.vim'
        Plugin 'vim-airline/vim-airline'
        Plugin 'vim-airline/vim-airline-themes'
        Plugin 'powerline/fonts'

        " All of the Plugins must be added before the following line
        call vundle#end()
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

" General {
    set background=dark             " Assume a dark background

    filetype plugin indent on       " Automatically detect file types
    syntax on                       " Syntax highlighting
"    set mouse=a                     " Automatically enable mouse usage
    set mousehide                   " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set nospell                         " Spell checking off
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " Disable restore cursor to file position in previous editing session
    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    function! ResCur()
        if line("'\"") <= line("$")
            silent! normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif
    " }
" }

" Vim UI {
    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {
    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks

    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()

    autocmd FileType puppet,ruby,yml setlocal shiftwidth=2 softtabstop=2 tabstop=2
" }

" Key (re)mappings {
    let mapleader = ','
    let maplocalleader = '_'

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
" }

" Plugins {
    " Solarized {
        if isdirectory(expand("~/.vim/bundle/vim-colors-solarized"))
            let g:solarized_termcolors=256
            let g:solarized_termtrans=1
            let g:solarized_contrast="normal"
            let g:solarized_visibility="normal"
            colorscheme solarized
        endif
    " }

    " NERDTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            map <C-e> :NERDTreeToggle<CR>
            map <leader>e :NERDTreeFind<CR> 	        nmap <leader>nt :NERDTreeFind<CR>
            nmap <leader>nt :NERDTreeFind<CR>

            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=2
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
        endif
    " }

    " vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        if isdirectory(expand("~/.vim/bundle/vim-airline-themes/"))
            if !exists('g:airline_theme')
                let g:airline_theme='dark'

                " Use the default set of separators with a few customizations
                let g:airline_left_sep='›'  " Slightly fancier than '>'
                let g:airline_right_sep='‹' " Slightly fancier than '<'
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

    " Initialize NERDTree as needed {
        function! NERDTreeInitAsNeeded()
            redir => bufoutput
                buffers!
            redir END
            let idx = stridx(bufoutput, "NERD_tree")

            if idx > -1
                NERDTreeMirror
                NERDTreeFind
                wincmd l
            endif
        endfunction
    " }

    " Toggle background {
        function! ToggleBG()
            let s:tbg = &background

            " Inversion
            if s:tbg == "dark"
                set background=light
            else
                set background=dark
            endif
        endfunction
        noremap <leader>bg :call ToggleBG()<CR>
    " }

    " Strip whitespaces {
        function! StripTrailingWhitespace()
            " Preparation: save last search, and cursor position
            let _s=@/
            let l = line(".")
            let c = col(".")
            " do the business:
            %s/\s\+$//e
            " clean up: restore previous search history, and cursor position
            let @/=_s
            call cursor(l, c)
        endfunction
    " }
" }
