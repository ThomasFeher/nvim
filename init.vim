let mapleader = 'ß'
let maplocalleader = 'ß'
set scrolloff=5

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
let g:tex_flavor = 'latex'
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
Plug 'ycm-core/YouCompleteMe', { 'do': function('BuildYCM') }
" :YcmGenerateConfig or
" :YcmGenerateConfig! for overwriting existing config
" for "color coded" use :CCGenerateConfig
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" git integration
Plug 'tpope/vim-fugitive'
" Git tree viewer
" g? in tree view to see mappings
nmap <leader>gv :Flog -all<cr>
Plug 'rbong/vim-flog'
Plug 'airblade/vim-gitgutter'
" <Leader>gm to open window with last commit changing the content under the
" cursor.
" Again <Leader>gm to switch into the window and have the following additional
" bindings:
" q 	Close the popup window
" o 	older. Back to older commit at the line
" O 	Opposite to o. Forward to newer commit at the line
" d 	Toggle diff hunks only related to current file in the commit
" D 	Toggle all diff hunks in the commit
" ? 	Show mappings help
Plug 'rhysd/git-messenger.vim'

" others
Plug 'ervandew/supertab'
Plug 'MPogoda/octave.vim--'
Plug 'tpope/vim-vinegar' " press `I` to change to old view, press `s` to change sorting
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-eunuch' " Move, Chmod, etc.
Plug 'neomake/neomake' " syntax checker
" ignore C/C++, they are already linted by YCM (and configuration of paths is
" hard with neomake
" copied from http://vi.stackexchange.com/a/4500/7823
let ftIgnore = ['cpp','c']
autocmd! BufWritePost,BufWinEnter * if index(ftIgnore,&ft) < 0 | Neomake
Plug 'PotatoesMaster/i3-vim-syntax'
"Plug 'bronson/vim-trailing-whitespace'
Plug 'rytkmt/vim-trailing-whitespace' " this fork handles GV windows correctly
Plug 'scrooloose/nerdcommenter'
Plug 'Raimondi/delimitMate'
Plug 'PProvost/vim-ps1'
" :Vista to open tag window
" <CR>  - jump to the tag under the cursor.
" p     - preview the tag under the context via the floating window if it's avaliable.
" s     - sort the symbol alphabetically or the location they are declared.
" q     - close the vista window.
Plug 'liuchengxu/vista.vim'
let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista_executive_for = {
    \ 'vimwiki': 'markdown',
    \ 'pandoc': 'markdown',
    \ 'markdown': 'toc',
    \ }
let g:vista_sidebar_position = 'vertical topleft'
" show context of current line
" use `:Context…` commands
Plug 'wellle/context.vim'
let g:context_filetype_blacklist = ['vista']
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating' " necessary for orgmode plugin
" use :MarkdownPreview to render markdown files in the browser
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'vimwiki/vimwiki'
" use vimwiki for markdown files
let g:vimwiki_ext2syntax = {'.md': 'markdown',
			\ '.mkd': 'markdown',
			\ '.wiki': 'media'}
" make vimwikis default syntax markdown
let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_markdown_link_ext = 1
" remove mapping that shadows vim-vinegars mapping to enter file browsing
nmap <Nop> <Plug>VimwikiRemoveHeaderLevel
" Zettelkasten for Vimwiki
" :ZettelNew create new zettel
" z in visual mode creates new zettel with highlighted text as title
" T in normal mode: yank the current note filename and title as a Vimwiki link
Plug 'michal-h21/vim-zettel'
let g:zettel_format = '%Y%m%d%H%M'
let g:zettel_fzf_command = 'ag'
" command: ga<movement><align-char>
Plug 'junegunn/vim-easy-align'
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wellle/targets.vim'
Plug 'haya14busa/incsearch.vim'
let g:incsearch#auto_nohlsearch = 1
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
let g:pandoc#modules#disabled = ['folding','formatting']
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
			\ 'CMakeLists.txt': {
			\   '*.cpp': {'type': 'source', 'alternate': '{}.h'},
			\   '*.c': {'type': 'source', 'alternate': '{}.h'},
			\   '*.h': {'type': 'header', 'alternate': '{}.cpp'}
			\ }
			\ }
nnoremap <leader>a :A<CR>
" use `:Autoformat` to format according to ".clang-format" file in project dir
Plug 'Chiel92/vim-autoformat'
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
" let CtrlP's root directory for searching be the recipe repository
let g:ctrlp_root_markers = ['recipes']
" diff two blocks in the same file
" mark first block and do :LineDiff
" mark second block and do :LineDiff
" exit diff view with :LineDiffReset
Plug 'AndrewRadev/linediff.vim'
" semantic highlighting of C/C++ files
Plug 'arakashic/chromatica.nvim'
let g:chromatica#libclang_path='/usr/lib64/libclang.so.8'
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
" TODO have a look at https://github.com/mechatroner/minimal_gdb to persist
" breakpoints
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
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
" Zeal for vim
" <leader>z on a word to search it in zeal (alternative :Zeavim or :ZeamvimV)
Plug 'KabbAmine/zeavim.vim'
" automatically highlighting other uses of the current word under the cursor
Plug 'RRethy/vim-illuminate'
" Menu bar using popup windows
" hit space twice to open menu
Plug 'skywind3000/vim-quickui'
" Entering a text window in Firefox will immediately start an instance of
" Neovim in an overlay window.
" :w - put content of buffer into the text window
" :q - close the Neovim overlay
" <C-e> - open Neovim overlay in current text window manually
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" Whenever cursor jumps some distance or moves between windows, it will flash
" so you can see where it is.
Plug 'danilamihailov/beacon.nvim'
" There is a bug when closing buffers created by Fugitive's :Gdiff, therefore
" ignoring those buffers for now.
let g:beacon_ignore_buffers = ["[Git]"]
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" FZF for vim
" :Files
" :GitFiles :GFiles
" :Buffers
" :Lines
" :BLines
" :Colors
" :Ag
" :Rg
" :Tags
" :BTags
" :Snippets
" :Commands
" :Marks
" :Helptags
" :Windows
" :Commits
" :BCommits
" :Maps
" :Filetypes
" :History
" install `bat` to get syntax highlighting in preview windows
Plug 'junegunn/fzf.vim'
" use floating window for FZF
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.5, 'highlight': 'Comment' } }
" AgIn: Start ag in the specified directory
" Source: https://github.com/junegunn/fzf.vim/issues/27#issuecomment-608294881
"
" e.g.
"   :AgIn .. foo
function! s:ag_in(bang, ...)
  if !isdirectory(a:1)
    throw 'not a valid directory: ' . a:1
  endif
  " Press `?' to enable preview window.
  call fzf#vim#ag(join(a:000[1:], ' '), fzf#vim#with_preview({'dir': a:1}), a:bang)
  " If you don't want preview option, use this
  " call fzf#vim#ag(join(a:000[1:], ' '), {'dir': a:1}, a:bang)
endfunction
command! -bang -nargs=+ -complete=dir AgIn call s:ag_in(<bang>0, <f-args>)
nmap <Leader>fzf :FZF '--preview'
Plug 'vim-scripts/TWiki-Syntax'
Plug 'stefandtw/quickfix-reflector.vim'
if has("nvim-0.5.0")
	" Statistics about your keystrokes
	Plug 'ThePrimeagen/vim-apm'
	" language parser for better syntax highlighting, refactoring, navigation,
	" text objects, folding and more
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'nvim-treesitter/nvim-treesitter-refactor'
	Plug 'nvim-treesitter/nvim-treesitter-textobjects'
	" Configuration for most commonly used language servers
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/popup.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
end
" Floating terminal integration
" see `Floaterm…` commands
" FloatermSend: send marked text to terminal
" FloatermToggle: toggle terminal window (creates new one in case none is
"                 existing, keeps terminal buffer once it was opened)
Plug 'voldikss/vim-floaterm'
let g:floaterm_keymap_toggle = '<Leader>ft'
call plug#end()

if has("nvim-0.5.0")
	"nvim-treesitter configuration
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "c", "cpp",     -- one of "all", "language", or a list of languages
  highlight = {
	enable = true,              -- false will disable the whole extension
	disable = {},  -- list of language that will be disabled
  },
  refactor = {
    highlight_definitions = { enable = true },
	highlight_current_scope = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      },
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    },
  },
  textobjects = {
    -- possible text objects:
    -- @block.inner
    -- @block.outer
    -- @call.inner
    -- @call.outer
    -- @class.inner
    -- @class.outer
    -- @comment.outer
    -- @conditional.inner
    -- @conditional.outer
    -- @function.inner
    -- @function.outer
    -- @loop.inner
    -- @loop.outer
    -- @parameter.inner
    -- @statement.outer
	select = {
	  enable = true,
	  keymaps = {
		["af"] = "@function.outer",
		["if"] = "@function.inner",
		["ac"] = "@class.outer",
		["ic"] = "@class.inner",
		},
	  },
	move = {
	  enable = true,
	  goto_next_start = {
		["]m"] = "@function.outer",
		["]]"] = "@class.outer",
	  },
	  goto_next_end = {
		["]M"] = "@function.outer",
		["]["] = "@class.outer",
	  },
	  goto_previous_start = {
		["[m"] = "@function.outer",
		["[["] = "@class.outer",
	  },
	  goto_previous_end = {
		["[M"] = "@function.outer",
		["[]"] = "@class.outer",
	  },
	},
	swap = {
	  enable = true,
	  swap_next = {
		["<leader>a"] = "@parameter.inner",
	  },
	  swap_previous = {
		["<leader>A"] = "@parameter.inner",
	  },
	},
  },
  indent = {
    enable = true,
  },
}
EOF
end

"
" Brief help
" :PlugList       - lists configured plugins
" :PlugInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PlugSearch foo - searches for foo; append `!` to refresh local cache
" :PlugClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? 'evim'
	finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set shiftwidth=4
set tabstop=4

if has('vms')
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
if &t_Co > 2 || has('gui_running')
	syntax enable
	set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has('autocmd')

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
if !exists(':DiffOrig')
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
				\ | wincmd p | diffthis
endif

"colorscheme molokai

inoremap üü <Esc>
nnoremap ö :w<CR>

" search for selected text
" source: http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap // y/<C-R>"<CR>

" toggle taglist
nnoremap <leader>tt :Vista!!<CR>
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
	exec 'match OverLength /\%'.&colorcolumn.'v.\+/'
else
	autocmd BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>79v.\+', -1)
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

" hide toolbar
set guioptions-=T

" this is only necessary for 256 color terminals, because solarized will not
" work there
if !has('gui_running')
	if $TERM =~? '^\(rxvt-.*\)\|\(.*16color\)$'
		" force 16 color support
		let g:solarized_use16 = 1
		set notermguicolors
	else
		let g:solarized_use16 = 0
		set termguicolors
	end
endif

" call :colorscheme in neovim to change colorscheme on the fly
set background=dark " set to "light" to switch to solarized light
" making it silent to allow automated installation of all plugins as described
" here: https://github.com/junegunn/vim-plug/issues/225
silent! colorscheme solarized8

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

" clang-format
map <leader>cf :pyfile /usr/share/clang/clang-format.py<cr>

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

" settings for ultisnips
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsListSnippets='<leader><tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsSnippetDirectories=['UltiSnips','/home/feher/.config/vic_snippets']

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
" why should we limit the number of warnings shown?
let g:ycm_max_diagnostics_to_display = 0
" mappings for YouCompleteMe
nnoremap <leader>go :YcmCompleter GoTo<CR>
nnoremap <leader>doc :YcmCompleter GetDoc<CR>
nnoremap <leader>type :YcmCompleter GetType<CR>
nnoremap <leader>fix :YcmCompleter FixIt<CR>
" fill in the new name at the end:
nnoremap <leader>ref :YcmCompleter RefactorRename<Space>
let g:ycm_key_detailed_diagnostics = '<leader>det'
let g:ycm_clangd_args = ['-background-index']
let g:ycm_filetype_blacklist = {
	\ 'tagbar': 1,
	\ 'notes': 1,
	\ 'netrw': 1,
	\ 'unite': 1,
	\ 'pandoc': 1,
	\ 'infolog': 1,
	\ 'leaderf': 1,
	\ 'mail': 1
	\}

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

set splitbelow
set splitright

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
	autocmd FileType markdown,vimwiki setlocal expandtab spell spelllang=en,de
augroup END

augroup cpp
	autocmd!
	autocmd FileType c,cpp setlocal comments-=:// comments+=://!,:///,:// spell
	autocmd FileType cpp setlocal matchpairs+=<:>
augroup END

" enable built-in doxygen syntax highlighting
let g:load_doxygen_syntax=1

" modify autocompletion behaviour
set wildmode=longest:full

" mappings for vim-bob
nmap <leader>bC :BobClean<CR>
nmap <leader>bi :BobInit<CR>
nmap <leader>bd :BobDev!<Space>
nmap <leader>br :BobDev! -DBUILD_TYPE=Release<s-left><left>
nmap <leader>bg :BobGoto<Space>
nmap <leader>bb :make!<CR>
nmap <leader>bp :BobProject!<Space>
let g:bob_config_path = 'configurations'
let g:bob_graph_type = 'dot'
let g:bob_auto_complete_items = ['-DBUILD_TYPE=Release', '-DBUILD_TYPE=Debug', '-DBUILD_SCRIPT_AS_SYMLINK=TRUE']

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
	autocmd BufWritePost *.uml,*.puml call jobstart('plantuml -tsvg ' . expand('<afile>')) | call jobstart('plantuml -tpng ' . expand('<afile>'))
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

" quickui settings
let g:quickui_show_tip = 1
let g:quickui_color_scheme = 'system'
noremap <space><space> :call quickui#menu#open()<cr>
call quickui#menu#reset()
call quickui#menu#install("&Option", [
			\ ['Set &Spell %{&spell? "Off":"On"}', 'set spell!'],
			\ ['Set &Cursor Line %{&cursorline? "Off":"On"}', 'set cursorline!'],
			\ ['Set &Paste %{&paste? "Off":"On"}', 'set paste!'],
			\ ['--', ''],
			\ ['YCM FixIt', 'YcmCompleter FixIt'],
			\ ['YCM Format', 'YcmCompleter Format'],
			\ ['YCM GetDoc', 'YcmCompleter GetDoc'],
			\ ['YCM GetDocImprecise', 'YcmCompleter GetDocImprecise'],
			\ ['YCM GetType', 'YcmCompleter GetType'],
			\ ['YCM GetTypeImprecise', 'YcmCompleter GetTypeImprecise'],
			\ ['YCM GoTo', 'YcmCompleter GoTo'],
			\ ['YCM GoToDeclaration', 'YcmCompleter GoToDeclaration'],
			\ ['YCM GoToDefinition', 'YcmCompleter GoToDefinition'],
			\ ['YCM GoToImprecise', 'YcmCompleter GoToImprecise'],
			\ ['YCM GoToInclude', 'YcmCompleter GoToInclude'],
			\ ['YCM GoToReferences', 'YcmCompleter GoToReferences'],
			\ ['YCM RefactorRename', 'YcmCompleter RefactorRename'],
			\ ])

" make popup-menu semi-transparent
set pumblend=10
set winblend=10

" to prevent losing connection between browser tab and markdown window in
" neovim (see https://github.com/iamcco/markdown-preview.nvim/issues/107)
let g:mkdp_auto_close = 0

" highlight the yanked part
" see https://github.com/neovim/neovim/issues/11872 for getting this natively
if has('nvim-0.4')  " {{{ TextYankPost highlight
  function! s:hl_yank(operator, regtype, inclusive) abort
    if a:operator !=# 'y' || a:regtype ==# ''
      return
    endif
    " edge cases:
    "   ^v[count]l ranges multiple lines

    " TODO:
    "   bug: ^v where the cursor cannot go past EOL, so '] reports a lesser column.

    let bnr = bufnr('%')
    let ns = nvim_create_namespace('')
    call nvim_buf_clear_namespace(bnr, ns, 0, -1)

    let [_, lin1, col1, off1] = getpos("'[")
    let [lin1, col1] = [lin1 - 1, col1 - 1]
    let [_, lin2, col2, off2] = getpos("']")
    let [lin2, col2] = [lin2 - 1, col2 - (a:inclusive ? 0 : 1)]
    for l in range(lin1, lin1 + (lin2 - lin1))
      let is_first = (l == lin1)
      let is_last = (l == lin2)
      let c1 = is_first || a:regtype[0] ==# "\<C-v>" ? (col1 + off1) : 0
      let c2 = is_last || a:regtype[0] ==# "\<C-v>" ? (col2 + off2) : -1
      call nvim_buf_add_highlight(bnr, ns, 'TextYank', l, c1, c2)
    endfor
    call timer_start(300, {-> nvim_buf_is_valid(bnr) && nvim_buf_clear_namespace(bnr, ns, 0, -1)})
  endfunc
  highlight default link TextYank Visual
  augroup vimrc_hlyank
    autocmd!
    autocmd TextYankPost * call s:hl_yank(v:event.operator, v:event.regtype, v:event.inclusive)
  augroup END
endif  " }}}

" store the complete hash of the current git commit in register `+`
command! Hash let @+ = execute("Git rev-parse HEAD")

if exists('g:started_by_firenvim')
	" generally use markdown syntax (from vimwiki)
	autocmd BufEnter *.txt set filetype=vimwiki
	" specialize here for certain pages (URL is always first part of file
	" name)
	"autocmd BufEnter github.com_*.txt set filetype=markdown
	autocmd BufEnter *redmine*.txt set filetype=textile | set textwidth=0
	" using Twiki syntax file and configuration suggested by https://twiki.org/cgi-bin/view/Codev/VimEditor
	autocmd BufEnter twiki*.txt set filetype=twiki | set expandtab | set softtabstop=3 | set tabstop=8 | set shiftwidth=3 | set textwidth=0
	" jupyter notebooks (it doesn't seem to be possible to get the kernel
	" name, unfortunately)
	"autocmd BufEnter *ipynb_er-DIV*.txt set filetype=python
	autocmd BufEnter *ipynb_er-DIV*.txt set filetype=octave
	autocmd BufEnter *ipynb_ontainer-DIV*.txt set filetype=vimwiki
    " for chat apps. Enter sends the message and deletes the buffer.
    " Shift enter is normal return. Insert mode by default.
	" Need to unmap vimwiki mappings beforehand.
    autocmd BufEnter *slack.com*,*gitter.im*,*element.io*
				\ execute "startinsert" |
				\ execute "iunmap <buffer> <CR>" |
				\ execute "inoremap <CR> <Esc>:w<CR>:call firenvim#press_keys(\"<LT>CR>\")<CR>ggdGa" |
				\ execute "iunmap <buffer> <s-CR>" |
				\ execute "inoremap <s-CR> <CR>" |
				\ set filetype=text |
				\ set textwidth=0
	autocmd BufEnter godbolt.org_*.txt set filetype=cpp
endif

if exists('&spelloptions')
    set spelloptions=camel
endif

set signcolumn=auto:9

" make popup menu usable via Tab key, equally as for YCM
cnoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
cnoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <Left>  pumvisible() ? "\<Up>" : "\<Left>"
cnoremap <expr> <Right> pumvisible() ? "\<Down>" : "\<Right>"

" Build neovim from source
command! MakeNeovim make "CMAKE_INSTALL_PREFIX=$HOME/bin/neovim" "CMAKE_BUILD_TYPE=RelWithDebInfo"
