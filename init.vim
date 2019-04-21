call plug#begin('~/.config/nvim/bundle')
function! BuildYCM(info)
	" info is a dictionary with 3 fields
	" - name:   name of the plugin
	" - status: 'installed', 'updated', or 'unchanged'
	" - force:  set on PlugInstall! or PlugUpdate!
	if a:info.status != 'unchanged' || a:info.force
		!./install.py --clang-completer --clangd-completer
	endif
endfunction

" color scheme
Plug 'lifepillar/vim-solarized8'

" LaTex
Plug 'lervag/vimtex' " LaTeX
let g:vimtex_fold_enabled = 0 " actvated folding slowes neovim down significantly
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
let g:vimtex_compiler_latexmk = {
	\ 'build_dir' : 'build'
	\}
if !exists('g:ycm_semantic_triggers')
	let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
			\ 're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
			\ 're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
			\ 're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
			\ 're!\\(include(only)?|input){[^}]*'
			\ ]

" autocompletion
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
" :YcmGenerateConfig or
" :YcmGenerateConfig! for overwriting existing config
" for "color coded" use :CCGenerateConfig
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" git integration
Plug 'tpope/vim-fugitive'
" gv - a possible replacement for gitv (unmaintained)
" o or <cr> on a commit to display the content of it
" o or <cr> on commits to display the diff in the range
" O opens a new tab instead
" gb for :Gbrowse
" ]] and [[ to move between commits
" . to start command-line with :Git [CURSOR] SHA à la fugitive
" q to close
Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'

" others
Plug 'ervandew/supertab'
Plug 'MPogoda/octave.vim--'
Plug 'tpope/vim-vinegar' " press `I` to change to old view, press `s` to change sorting
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-eunuch' " Move, Chmod, etc.
Plug 'neomake/neomake' " syntax checker
" ignore C/C++, they are already linted by YCM (and configuration of paths is
" hard with neomke
" copied from http://vi.stackexchange.com/a/4500/7823
let ftIgnore = ['cpp','c']
autocmd! BufWritePost,BufWinEnter * if index(ftIgnore,&ft) < 0 | Neomake
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'bronson/vim-trailing-whitespace'
Plug 'scrooloose/nerdcommenter'
Plug 'Raimondi/delimitMate'
Plug 'PProvost/vim-ps1'
Plug 'yazug/vim-taglist-plus'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating' " necessary for orgmode plugin
Plug 'vimwiki/vimwiki'
" use vimwiki for markdown files
let g:vimwiki_ext2syntax = {'.md': 'markdown',
			\ '.mkd': 'markdown',
			\ '.wiki': 'media'}
" make vimwikis default syntax markdown
let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
" command: ga<movement><align-char>
Plug 'junegunn/vim-easy-align'
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
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
" store tag files in /tmp directory
let g:gutentags_cache_dir = '/tmp'
Plug 'thinca/vim-quickrun' " execute code in current buffer
Plug 'chrisbra/csv.vim'
Plug 'vim-pandoc/vim-pandoc'
let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#modules#disabled = ["folding","formatting"]
Plug 'sjl/clam.vim' " execute console commands and put result in buffer
Plug 'kien/ctrlp.vim' " fuzzy file finder
" scan unlimited number of files
let g:ctrlp_max_files = 0
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
Plug 'jamessan/vim-gnupg' " read and write gnupg encrypted files (.gpg,.pgp,.asc)
Plug 'chrisbra/NrrwRgn' " work on a specified region in a separate buffer (<leader>nr or :NrrwRgn)
" use gits improved diff algorithms (:h EnhancedDiff, :EnhancedDiff <algorithm)
Plug 'chrisbra/vim-diff-enhanced'
" diff viewer on directory level, usage: :DirDiff <dir1> <dir2>
Plug 'will133/vim-dirdiff'
Plug 'tpope/vim-projectionist' " :A open alternative file, :E<groupname> <filename>
" default projections
let g:projectionist_heuristics = {
			\ "CMakeLists.txt": {
			\   "*.cpp": {"type": "source", "alternate": "{}.h"},
			\   "*.c": {"type": "source", "alternate": "{}.h"},
			\   "*.h": {"type": "header", "alternate": "{}.cpp"}
			\ }
			\ }
nnoremap <leader>a :A<CR>
" search in source code files
" faster than (vim)grep and ack, needs `the_silver_searcher` package installed
" use `:Ag <search-term>`
" `:h Ag`
Plug 'rking/ag.vim'
let g:ag_working_path_mode="r" " start search from project root directory
" use `:Autoformat` to format according to ".clang-format" file in project dir
Plug 'Chiel92/vim-autoformat'
"Plug 'jeaye/color_coded', {'do': 'cmake . && make && make install && make clean && make clean_clang'} " improved syntax highlighting (needs gcc 4.9 or higher, so not usable on openSUSE 13.2)
" unterstützt aber kein Neovim, anscheinend arbeitet YCM an einer API um
" solche Plugins zu unterstützen. Ein
" [MR](https://github.com/Valloric/ycmd/pull/291) ist kurz vorm merge. Dann
" könnte man [dieses Plugin](https://github.com/davits/DyeVim) benutzen.
" start with <leader>rf, run current line <leader>ll, run current selection
" <leader>ss, quit <leader>rq, hilfe :h Nvim-R
Plug 'jalvesaq/Nvim-R'
" fold python functions and classes
Plug 'tmhedberg/SimpylFold'
" edit surrounding tags, quotes, etc.
" change next surrounding double quotes to single quotes: cs"'
" add ("yank") double quotes around current word: ysiw"
" delete next surrounding single quotes: ds'
Plug 'tpope/vim-surround'
" dot command repeats plugin mappings, too, if supported by the plugin (e.g.
" vim-surround)
Plug 'tpope/vim-repeat'
" syntax highlighting for PlantUML
" The filetype will be set to plantuml for *.pu, *.uml or *.plantuml files or
" if the first line of a file contains @startuml.
" Additionally the makeprg is set to plantuml.
Plug 'aklt/plantuml-syntax'
" Syntax highlighting and more for Julia language
Plug 'JuliaEditorSupport/julia-vim'

Plug 'ThomasFeher/vim-bob' " changes makeprg when in Bob environment
let g:bob_config_path = "configurations"
" let CtrlP's root directory for searching be the recipe repository
let g:ctrlp_root_markers = ['recipes']
" diff two blocks in the same file
" mark first block and do :LineDiff
" mark second block and do :LineDiff
" exit diff view with :LineDiffReset
Plug 'AndrewRadev/linediff.vim'
" semantic highlighting of C/C++ files
Plug 'arakashic/chromatica.nvim'
let g:chromatica#libclang_path='/usr/lib64/libclang.so.4'
Plug 'editorconfig/editorconfig-vim'
" This plugin adds text object support for comma-separated arguments enclosed
" by brackets.
" usage: aa (an argument, includes the separator) or
"        ia (inner argument, excludes the separator))
Plug 'b4winckler/vim-angry'
" <leader> dd start debugging with gdb
" <leader> dp start debugging python
" F8 :GdbBreakpointToggle
" F5 :GdbContinue
" F10 :GdbNext
" F11 :GdbStep
" F12 :GdbFinish
" <C-p> :GdbFrameUp
" <C-n> :GdbFrameDown
Plug 'sakhnik/nvim-gdb'
" modern matchit and matchparen replacement
" %: as usual
" g%: like % but backwards
" [%: previous surrounding open word
" ]%: next surrounding close word
" objects:
" i%: the inside of an 'any block'
" 1i%: the inside of an 'open-to-close block'
" a%: an 'any block'
" 1a%: an 'open-to-close block'
Plug 'andymass/vim-matchup'
" multi-pane file manager for Neovim with fuzzy matching
" start: :Tc (mnemonic: total commander)
Plug 'philip-karlsson/bolt.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()
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
	syntax enable
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

let mapleader = "ß"
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
" navigate out of terminal mode
tnoremap <leader><left> <C-\><C-N><C-W>h
tnoremap <leader><right> <C-\><C-N><C-W>l
tnoremap <leader><up> <C-\><C-N><C-W>k
tnoremap <leader><down> <C-\><C-N><C-W>j

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

" this is only necessary for 256 color terminals, because solarized will not
" work there
if !has("gui_running")
	" force 16 color support
	let g:solarized_use16 = 1
endif

" call :colorscheme in neovim to change colorscheme on the fly
set background=dark " set to "light" to switch to solarized light
colorscheme solarized8

" disable autotag, set to 0 or delete to activate autotag
"let g:autotag_vim_version_sourced=1

" airline
let g:airline_powerline_fonts = 1
" taken from :help airline
let g:airline_mode_map = {
			\ '__' : '-',
			\ 'n'  : 'N',
			\ 'i'  : 'I',
			\ 'R'  : 'R',
			\ 'c'  : 'C',
			\ 'v'  : 'V',
			\ 'V'  : 'V',
			\ '' : 'V',
			\ 's'  : 'S',
			\ 'S'  : 'S',
			\ '' : 'S',
			\ }

" fugitive
set diffopt=filler,vertical
nnoremap <leader>gs :Gstatus<CR>

" gv
nmap <leader>gv :GV --all<cr>

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
let g:ycm_autoclose_preview_window_after_insertion = 1
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
" the default of 50 is to small in some cases when completing filepaths
let g:ycm_max_num_candidates = 200
" mappings for YouCompleteMe
nnoremap <leader>go :YcmCompleter GoTo<CR>
nnoremap <leader>doc :YcmCompleter GetDoc<CR>
nnoremap <leader>type :YcmCompleter GetType<CR>
nnoremap <leader>fix :YcmCompleter FixIt<CR>
let g:ycm_key_detailed_diagnostics = '<leader>det'
let g:ycm_clangd_args = ["-background-index"]

" highlight current column
set cursorcolumn
" highlight current line
set cursorline

" row numbering
set number
set relativenumber

" ignore case if search string is lower case only
set ignorecase
set smartcase

" show wrapped lines

" set spell checking in commit messages
autocmd FileType gitcommit setlocal spell

" do not use tabs in markdown documents, because that would give inconsistent
" indentation
" example:
" * something long that has to be broken into several lines and is already
"   indented
" ^^ here we need spaces, having tabs for indentation in front of it would be
" messy
augroup markdown
	au!
	autocmd FileType markdown,vimwiki setlocal expandtab spell
augroup END

" vimwiki
nnoremap <leader>w/ :VimwikiSearch 
nnoremap <leader>/ :VimwikiSearch 

" modify autocompletion behaviour
set wildmode=longest:full

" mappings for vim-bob
nmap <leader>bC :BobClean<CR>
nmap <leader>bi :BobInit<CR>
nmap <leader>bd :BobDev! 
nmap <leader>br :BobDev! -DBUILD_TYPE=Release<s-left><left>
nmap <leader>bg :BobGoto 
nmap <leader>bb :make!<CR>
nmap <leader>bp :BobProject! 

" mappings for building with make and Neomake, respectively
" run make in foreground
nmap <leader>mm :make!<CR>
" run make in background
nmap <leader>MM :Neomake!<CR>
let g:neomake_error_sign = {'text': '✖', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {
	 \   'text': 'W',
	 \   'texthl': 'NeomakeWarningSign',
	 \ }
let g:neomake_message_sign = {
	  \   'text': 'M',
	  \   'texthl': 'NeomakeMessageSign',
	  \ }
let g:neomake_info_sign = {'text': 'I', 'texthl': 'NeomakeInfoSign'}

augroup uml
	"Remove all uml autocommands
	autocmd!
	autocmd BufWritePost *.uml,*.puml silent !plantuml <afile>
augroup END

augroup cpp
	autocmd!
	autocmd FileType c,cpp setlocal comments-=:// comments+=://!,:///,://
augroup END

" let gitgutter update more often than the default 4 seconds
set updatetime=100

" commands for changing directory to current file's directory
command! CdFile cd %:p:h
command! LcdFile lcd %:p:h

" key bindings for CtrlP
nnoremap <leader>pp :CtrlP<CR>
nnoremap <leader>pb :CtrlPBuffer<CR>

" show result of substitution command while typing it
set inccommand=split

" enable better indentation in case of soft wrapping
set breakindent
