" Environment {
    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win16') || has('win32') || has('win64'))
        endfunction
    " }
    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
            set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME
        endif
    " }

" }

" Encoding {
    set encoding=utf-8    
    set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
    set termencoding=utf-8
    set ffs=unix,dos,mac
" }


" General {

    set background=dark         " Assume a dark background
    if !has('gui')
        set term=$TERM          " Make arrow and other keys work
    endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8
    set encoding=utf-8          
    set termencoding=utf-8
    set fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,chinese,cp936

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " Most prefer to automatically switch to the current file directory when a new buffer is opened;
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set autoread
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving

" }

" Vim UI {

    " Avoid garbled characters in Chinese language windows OS
    let $LANG='en' 
    set langmenu=en
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    " Set extra options when running in GUI mode
    if has("gui_running")
        set guioptions-=T
        set guioptions-=e
        set t_Co=256
        set guitablabel=%M\ %t
    endif

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode
    set cursorline                  " Highlight current line
    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set lazyredraw                  " redraw only when we need to.

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
" }

" map {
    "let mapleader = ","
    "let g:mapleader = ","
    let mapleader = "\<space>"
    let g:mapleader = "\<space>"

    map j gj
    map k gk

    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_
    
    vmap <leader>y "+y
    vmap <leader>d "+d
    nmap <leader>p "+p
    nmap <leader>P "+P
    vmap <leader>p "+p
    vmap <leader>P "+P

    nnoremap <leader>w :w<CR>

    nmap <silent> <leader>/ :nohlsearch<CR>

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " highlight last inserted text
    nnoremap gV `[v`]

    " edit vimrc/zshrc and load vimrc bindings
    nnoremap <leader>ec :vsp $MYVIMRC<CR>
    nnoremap <leader>sc :source $MYVIMRC<CR>

    " Bash like keys for the command line
    cnoremap <C-A>		<Home>
    cnoremap <C-E>		<End>
    cnoremap <C-K>		<C-U>

    cnoremap <C-P> <Up>
    cnoremap <C-N> <Down>
"}

" Functions {

    " Initialize directories {
    function! InitializeDirectories()
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        let common_dir = $HOME . '/.vim/'

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



" Bundles {
    set nocompatible              " be iMproved, required
    filetype off                  " required

    set rtp+=~/.vim/bundle/Vundle.vim/
    call vundle#rc()
    " let Vundle manage Vundle, required
    Bundle 'gmarik/Vundle.vim'

    " syntax {
    Bundle 'scrooloose/syntastic'
    " }

    " solarized { 
    Bundle 'altercation/vim-colors-solarized'
    set background=dark
    let g:solarized_italic=0
    colorscheme solarized
    " }

"    " youcompleteme {
"    Bundle 'Valloric/YouCompleteMe'
"    let g:ycm_goto_buffer_command = 'horizontal-split'
"    " nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
"    nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
"    nnoremap <leader>gd :YcmCompleter GoToDeclaration<CR>
"    if !empty(glob("~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"))
"        let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
"    endif
"    " }
    
    " easymotion {
    Bundle 'Lokaltog/vim-easymotion'
    let g:EasyMotion_smartcase = 1
    " let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
    map <Leader><leader>h <Plug>(easymotion-linebackward)
    map <Leader><Leader>j <Plug>(easymotion-j)
    map <Leader><Leader>k <Plug>(easymotion-k)
    map <Leader><leader>l <Plug>(easymotion-lineforward)
    map  <leader>/ <Plug>(easymotion-sn)
    omap <leader>/ <Plug>(easymotion-tn)
    " }

    " ctrlp {
    Bundle 'ctrlpvim/ctrlp.vim'
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'
    map <leader>r :CtrlPMRU<CR>
    "set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux"
    let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
        \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz)$',
        \ }
    "\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
    let g:ctrlp_working_path_mode=0
    let g:ctrlp_match_window_bottom=1
    let g:ctrlp_max_height=15
    let g:ctrlp_match_window_reversed=0
    let g:ctrlp_mruf_max=500
    let g:ctrlp_follow_symlinks=1
    if executable('ag')
        let g:ctrlp_user_command = 'ag -l --nocolor -g "" %s'
    else
        let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'
    endif
    " }

    " ctrlp-funky {
    Bundle 'tacahiroy/ctrlp-funky'
    map <Leader>f :CtrlPFunky<Cr>
    " narrow the list down with a word under cursor
    map <Leader>F :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
    let g:ctrlp_funky_syntax_highlight = 1
    let g:ctrlp_extensions = ['funky']
    " }
    
   
    " ag.vim {
    Bundle 'rking/ag.vim'
    "let g:agprg="ag --column"
    nnoremap \ :Ag<SPACE>
    
    if executable('ag')
        nnoremap K :silent! Ag! "\b<C-R><C-W>\b"<CR>:cw<CR>
    else
        nnoremap K :silent! grep! "<C-R><C-W>" *<CR>:cw<CR>
    endif
    " }
    

    " multiple-cursors {
    Bundle 'http://github.com/terryma/vim-multiple-cursors.git'
    " }

    "vim-commentray {
    Bundle "tpope/vim-commentary"
    " for python and shell
    autocmd FileType python,shell set commentstring=#\ %s                 
    autocmd FileType mako set cms=##\ %s
    " }
    
    
    " neocomplete {
    Bundle 'Shougo/neocomplete.vim'
    "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
      " For no inserting <CR> key.
      "return pumvisible() ? "\<C-y>" : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

    " AutoComplPop like behavior.
    "let g:neocomplete#enable_auto_select = 1

    " Shell like behavior(not recommended).
    "set completeopt+=longest
    "let g:neocomplete#enable_auto_select = 1
    "let g:neocomplete#disable_auto_complete = 1
    "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

    " supertab {
    Bundle 'ervandew/supertab'
    let g:SuperTabDefaultCompletionType = "<c-p>"
    " }



    filetype plugin indent on    " required
" }
