call plug#begin('~/.config/nvim/bundle')
function! BuildYCM(info)
	" info is a dictionary with 3 fields
	" - name:   name of the plugin
	" - status: 'installed', 'updated', or 'unchanged'
	" - force:  set on PlugInstall! or PlugUpdate!
	if a:info.status == 'installed' || a:info.force
		!./install.py
	endif
endfunction

" color scheme
Plug 'altercation/vim-colors-solarized'

" LaTex
"Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'lervag/vimtex' " LaTeX
let g:vimtex_fold_enabled = 1
let g:vimtex_latexmk_build_dir = 'build'
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique @pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
let g:vimtex_latexmk_callback = 0
let g:vimtex_latexmk_continuous = 0

" autocompletion
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" git integration
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'
Plug 'airblade/vim-gitgutter'

" others
Plug 'ervandew/supertab'
Plug 'MPogoda/octave.vim--'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-eunuch' " Move, Chmod, etc.
Plug 'benekastah/neomake' " syntax checker
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'bronson/vim-trailing-whitespace'
Plug 'scrooloose/nerdcommenter'
Plug 'Raimondi/delimitMate'
Plug 'PProvost/vim-ps1'
Plug 'yazug/vim-taglist-plus'
Plug 'jceb/vim-orgmode'
Plug 'vimwiki/vimwiki'
" use vimwiki for markdown files
let g:vimwiki_ext2syntax = {'.md': 'markdown',
			              \ '.mkd': 'markdown',
			              \ '.wiki': 'media'}
Plug 'junegunn/vim-easy-align'
Plug 'bling/vim-airline'
Plug 'wellle/targets.vim'
Plug 'haya14busa/incsearch.vim'
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
Plug 'haya14busa/incsearch-fuzzy.vim'
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)
Plug 'ludovicchabant/vim-gutentags' " update tag files automatically
Plug 'thinca/vim-quickrun' " execute code in current buffer
Plug 'chrisbra/csv.vim'
"Plug 'vim-pandoc/vim-pandoc'
let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#modules#disabled = ["folding","formatting"]
Plug 'sjl/clam.vim' " execute console commands and put result in buffer
Plug 'kien/ctrlp.vim' " fuzzy file finder
Plug 'kassio/neoterm' " REPL functionality and terminal functions
Plug 'bfredl/nvim-ipy' " jupyter for neovim

function! BuildComposer(info)
	if a:info.status != 'unchanged' || a:info.force
		!cargo build --release
		UpdateRemotePlugins
	endif
endfunction
"Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
" press gS to split expressions on multiple lines
" press gJ to join multiline expressions on one line
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/switch.vim' " press gs to x.y → x->y or && → || or true → false

call plug#end()            " required
filetype plugin indent on    " required
"
" Brief help
" :PlugList       - lists configured plugins
" :PlugInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PlugSearch foo - searches for foo; append `!` to refresh local cache
" :PlugClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set shiftwidth=4
set tabstop=4

if has("vms")
  set nobackup " do not keep a backup file, use versions instead
else
  set backup " keep a backup file
endif
set history=50 " keep 50 lines of command line history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching

" store backup files in /tmp directory
set backupdir=/tmp
" store swap files in /tmp directory
set directory=/tmp

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 80 characters.
  autocmd FileType text setlocal textwidth=80

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
\ | wincmd p | diffthis
endif

"colorscheme molokai

let mapleader="ß"
let g:mapleader="ß"
let maplocalleader = "ß"
" mapleader should not time out
" set notimeout

inoremap üü <Esc>
nnoremap ö :w<CR>

" search for selected text
" source: http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap // y/<C-R>"<CR>

" toggle taglist
nnoremap <leader>tt :TlistToggle<CR>
let Tlist_GainFocus_On_ToggleOpen = 0 " Jump to taglist window on open.
let Tlist_Close_On_Select = 0 " Close the taglist window when a file or tag is selected.
"taglist automatic folding of unvisible files
let Tlist_File_Fold_Auto_Close=1
" display prototypes intstead of tags (used only because of ctags bug with
" pjsip
let Tlist_Display_Prototype=0
let Tlist_WinWidth = 60

" Move entire line/block up and down
"nnoremap <C-S-DOWN> :m+<CR>==
"nnoremap <C-S-UP> :m-2<CR>==
"inoremap <C-S-DOWN> <Esc>:m+<CR>==gi
"inoremap <C-S-UP> <Esc>:m-2<CR>==gi
"vnoremap <C-S-DOWN> :m'>+<CR>gv=gv
"vnoremap <C-S-UP> :m-2<CR>gv=gv

" Highlight on overlenght
if exists('+colorcolumn')
	set colorcolumn=81
	highlight link OverLength ColorColumn
	exec 'match OverLength /\%'.&cc.'v.\+/'
else
	au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>79v.\+', -1)
endif 

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" navigate between windows
nnoremap <leader><left> <C-W>h
nnoremap <leader><right> <C-W>l
nnoremap <leader><up> <C-W>k
nnoremap <leader><down> <C-W>j
nnoremap <leader><home> 0<C-W>w

" tag navigation
	"jump to tag
nnoremap <leader><CR> <C-]>
	" jump to tag in new vertical split
	" show tag in preview window
nnoremap <leader>~ <C-W>}
	" close preview window
nnoremap <leader><Bar> <C-W>z
	"back to last jump position
"nmap <leader><insert> <C-T>
nnoremap <leader><insert> <C-T>
" programming
"nnoremap cn :cn<return>
"nnoremap cp :cp<return>
" ignore warnings in quickfix window !!use with care!!
"set errorformat^=%-G%f:%l:\ warning:%m
" ignore notes in quickfix window !!use with care!!
"set errorformat^=%-G%f:%l:\ note:%m

" fold navigation
nmap z<up> zk
nmap z<down> zj

set guifont=Monospace\ 8,\ Lucida_Console:h8:cANSI
"set guifont=Monospace\ 10
"set guifont=Lucida_Console:h8:cANSI

" hide toolbar
set guioptions-=T

" force 256 color support
" set t_Co=256
set t_Co=16

" disable autotag, set to 0 or delete to activate autotag
"let g:autotag_vim_version_sourced=1

" airline
let g:airline_powerline_fonts = 1

" fugitive
set diffopt=filler,vertical
nnoremap <leader>gs :Gstatus<CR>

" gitv
nmap <leader>gv :Gitv --all<cr>
nmap <leader>gV :Gitv! --all<cr>
vmap <leader>gV :Gitv! --all<cr>

syntax enable
set background=dark
colorscheme solarized

" clang-format
map <leader>f :pyfile /usr/share/clang/clang-format.py<cr>

" quit ConqueTerm when program running in ConqueTerm quits
let g:ConqueTerm_CloseOnEnd = 1

" clang complete
let g:clang_snippets=1
let g:clang_snippets_engine = 'clang_complete'
"let g:clang_snippets_engine = 'ultisnips'
let g:clang_close_preview=1
" to debug clang complete
"let g:clang_debug=1
"let g:clang_complete_auto = 1
"let g:clang_complete_copen = 1

" LaTeX-Box
let g:LatexBox_output_type = "pdf"
let g:LatexBox_quickfix = 2 " do not jump to quickfix window
let g:LatexBox_Folding = 1
let g:LatexBox_viewer = "okular"

" set language to english independent of system language
let g:fugitive_git_executable = 'LANG=en_US git'

" syntastic
" make syntastic C++11 aware
let g:syntastic_cpp_compiler_options = ' -std=c++11'
" use location list (jump to errors with :lne and :lp)
let g:syntastic_always_populate_loc_list=1

" settings for ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<leader><tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" with python 3 snippets are not shown in YouCompleteMe list
let g:UltiSnipsUsePythonVersion = 2

" YouCompleteMe
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_seed_identifiers_with_syntax = 1
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" highlight current column
set cursorcolumn
