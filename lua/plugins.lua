local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_set_keymap('n', 'ä', ']', {})
vim.api.nvim_set_keymap('n', 'ü', '[', {})

return require('lazy').setup({
	{ 'lervag/vimtex', init = function()
		vim.g.tex_flavor = 'latex'
		vim.g.vimtex_fold_enabled = 0 -- actvated folding slowes neovim down significantly
		vim.g.vimtex_view_general_viewer = 'okular'
		vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'
		vim.g.vimtex_compiler_latexmk = { build_dir = 'build' }
		vim.g.vimtex_syntax_enabled = 0  -- using treesitter for syntax highlighting
		vim.g.vimtex_syntax_conceal_disable = 1  -- no conceal available when using treesitter
		end,
	},
	{ 'chomosuke/typst-preview.nvim',
	  lazy = false, -- or ft = 'typst'
	  version = '1.*',
	  opts = {}, -- lazy.nvim will implicitly call `setup {}`
	},

	-- Snippes
	'honza/vim-snippets',
	{ "L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		config = function ()
			require("luasnip.loaders.from_snipmate").lazy_load()
		end,
		dependencies = 'honza/vim-snippets',
	},

	-- Git integration
	{ 'tpope/vim-fugitive', config = function()
		vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', {noremap = true})
		end,
	},
	-- Git tree viewer
	-- g? in tree view to see mappings
	-- '@ jump to current HEAD
	{ 'rbong/vim-flog',
		lazy = true,
		cmd = { "Flog", "Flogsplit", "Floggit" },
		dependencies = {
			"tpope/vim-fugitive",
		},
	},
	{ 'airblade/vim-gitgutter' },
	-- <Leader>gm to open window with last commit changing the content under the
	-- cursor.
	-- Again <Leader>gm to switch into the window and have the following additional
	-- bindings:
	-- q 	Close the popup window
	-- o 	older. Back to older commit at the line
	-- O 	Opposite to o. Forward to newer commit at the line
	-- d 	Toggle diff hunks only related to current file in the commit
	-- D 	Toggle all diff hunks in the commit
	-- ? 	Show mappings help
	'rhysd/git-messenger.vim',

	-- File handling
	--   -: enter file explorer
	--   s: change sorting
	--   I: change to old view
	'tpope/vim-vinegar',
	--   :Chmod
	--   :Copy
	--   :Mkdir
	--   :Move
	--   :Remove
	--   :SudoEdit
	--   and more
	'tpope/vim-eunuch',

	{ 'vimwiki/vimwiki',  branch = 'dev', init = function()
			-- use vimwiki for markdown files
			vim.g.vimwiki_ext2syntax = { ['.md'] = 'markdown', ['.mkd'] = 'markdown', ['.wiki'] = 'media' }
			-- make vimwikis default syntax markdown
			vim.g.vimwiki_list = { {path = '~/vimwiki', syntax = 'markdown', ext = '.md'} }
			vim.g.vimwiki_markdown_link_ext = 1
			vim.g.vimwiki_filetypes = {'markdown'}
			-- remove mapping that shadows automatic indentation (==) which is not needed
			-- in vimwiki, but sometimes we need to switch vimwiki files that are initially
			-- of type vimwiki to another filetype where automatic indentation is needed,
			-- especially in firenvim
			vim.keymap.set('n', '<Nop>', '<Plug>VimwikiAddHeaderLevel')
			-- remove mapping that shadows vim-vinegars mapping to enter file browsing
			vim.keymap.set('n', '<Nop>', '<Plug>VimwikiRemoveHeaderLevel')
			vim.treesitter.language.register('markdown', 'vimwiki')
		end,
	},

	-- Tree-sitter
	-- language parser for better syntax highlighting, refactoring, navigation,
	-- text objects, folding and more
	{ 'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	config = function()
		require'nvim-treesitter.configs'.setup {
			ensure_installed = {"bash", "c", "cmake", "cpp", "latex", "lua", "python", "vim"},     -- one of "all", "language", or a list of languages
			highlight = {
				enable = true,              -- false will disable the whole extension
				disable = {},  -- list of language that will be disabled
			},
			--[=[
			refactor = {
				highlight_definitions = { enable = true },
				highlight_current_scope = { enable = false },
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
			--[=[
			indent = {
				enable = true,
			},
			--]=]
			incremental_selection = {
				enable = true,
				-- keymaps = {
					-- 	init_selection = '<CR>',
					-- 	scope_incremental = '<CR>',
					-- 	node_incremental = '<TAB>',
					-- 	node_decremental = '<S-TAB>',
					-- },
				},
			}
		end,
	dependencies = {
		'nvim-treesitter/nvim-treesitter-refactor',
		'nvim-treesitter/nvim-treesitter-textobjects',
		'nvim-treesitter/playground',
	},
	},
	{ 'nvim-treesitter/nvim-treesitter-context',
	dependencies = 'nvim-treesitter/nvim-treesitter',
	config = function() require'treesitter-context'.setup {
		enable = true,
		max_lines = 0,
		patterns = {
			default = {
				'class',
				'struct',
				'function',
				'method',
				'for',
				'while',
				'if',
				'switch',
				'case',
			}
		}
	}
	end
	},

	-- Modify quickfix (and location list) entries, writing these modifications will modify the original parts
	'stefandtw/quickfix-reflector.vim',
	'vim-scripts/TWiki-Syntax',
	-- FZF for vim
	-- :Files
	-- :GitFiles :GFiles
	-- :Buffers
	-- :Lines
	-- :BLines
	-- :Colors
	-- :Ag
	-- :Rg
	-- :Tags
	-- :BTags
	-- :Snippets
	-- :Commands
	-- :Marks
	-- :Helptags
	-- :Windows
	-- :Commits
	-- :BCommits
	-- :Maps
	-- :Filetypes
	-- :History
	-- install `bat` to get syntax highlighting in preview windows
	{ 'junegunn/fzf', build = 'fzf#install()' },
	{ 'junegunn/fzf.vim',
	dependencies = 'junegunn/fzf',
	init = function()
		-- use floating window for FZF
		vim.g.fzf_layout = { window = { width = 0.8, height = 0.5, highlight = 'Comment' } }
	end,
	config = function()
		vim.keymap.set('n', '<Leader>fzf', ':FZF<CR>')
		vim.keymap.set('n', '<Leader>fb', ':Buffers<CR>')
		vim.keymap.set('n', '<Leader>fl', ':Lines<CR>')
		vim.keymap.set('n', '<Leader>fj', ':Jumps<CR>')
		vim.keymap.set('n', '<Leader>fc', ':Commits<CR>')
		-- AgIn: Start ag in the specified directory
		-- Source: https://github.com/junegunn/fzf.vim/issues/27#issuecomment-608294881
		--
		-- e.g.
		--   :AgIn .. following
		vim.cmd(
				[[
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
				]]
			)
	end },
	-- modern matchit and matchparen replacement
	-- %: as usual
	-- g%: like % but backwards
	-- [%: previous surrounding open word
	-- ]%: next surrounding close word
	-- objects:
	-- i%: the inside of an 'any block'
	-- 1i%: the inside of an 'open-to-close block'
	-- a%: an 'any block'
	-- 1a%: an 'open-to-close block'
	{ 'andymass/vim-matchup', init = function()
		-- does in more situations the correct thing that `autocmd FileType cpp setlocal matchpairs+=<:>`
		vim.g.matchup_matchpref = {cpp = {template = 1}}
	end },
	-- Zeal for vim
	-- <leader>z on a word to search it in zeal (alternative :Zeavim or :ZeamvimV)
	'KabbAmine/zeavim.vim',
	-- automatically highlighting other uses of the current word under the cursor
	'RRethy/vim-illuminate',
	-- Diff two blocks in the same file
	-- mark first block and do :Linediff
	-- mark second block and do :Linediff
	-- exit diff view with :LinediffReset
	'AndrewRadev/linediff.vim',
	-- Integration of https://github.com/BobBuildTool/bob into Neovim
	{ 'ThomasFeher/vim-bob' , init = function()
		vim.keymap.set('n', '<leader>bb', ':make!<CR>', { noremap = true })
		vim.keymap.set('n', '<leader>bC', ':BobClean<CR>', { noremap = true })
		vim.keymap.set('n', '<leader>bd', ':BobDev!<Space>', { noremap = true })
		vim.keymap.set('n', '<leader>bg', ':BobGoto<Space>', { noremap = true })
		vim.keymap.set('n', '<leader>bi', ':BobInit<CR>', { noremap = true })
		vim.keymap.set('n', '<leader>bo', ':BobOpen<Space>', { noremap = true })
		vim.keymap.set('n', '<leader>bp', ':BobProject!<Space>', { noremap = true })
		vim.keymap.set('n', '<leader>bs', ':BobSearchSource<Space>', { noremap = true })
		vim.g.bob_config_path = 'configurations'
		vim.g.bob_graph_type = 'dot'
		vim.g.bob_auto_complete_items = { '-DBUILD_TYPE=Release',
			                              '-DBUILD_TYPE=Debug',
		                           	      '-DBUILD_SCRIPT_AS_SYMLINK=TRUE',
		                                  '--destination '}
	end},
	-- syntax highlighting for PlantUML
	-- The filetype will be set to plantuml for *.pu, *.uml or *.plantuml files or
	-- if the first line of a file contains @startuml.
	-- Additionally the makeprg is set to plantuml.
	'aklt/plantuml-syntax',
	-- fold python functions and classes
	-- use zR to open all folds
	-- and zM to close all folds
	-- or zi to toggle folding completely
	'tmhedberg/SimpylFold',
	-- edit surrounding tags, quotes, etc.
	-- cs"': change next surrounding double quotes to single quotes
	-- ysiw": add ("yank") double quotes around current word
	-- ds': delete next surrounding single quotes
	'tpope/vim-surround',
	-- dot command repeats plugin mappings, too, if supported by the plugin (e.g.
	-- vim-surround)
	'tpope/vim-repeat',
	-- diff viewer on directory level
	-- :DirDiff <dir1> <dir2>
	'will133/vim-dirdiff',
	-- press gS to split expressions on multiple lines
	-- press gJ to join multiline expressions on one line
	'AndrewRadev/splitjoin.vim',
	-- press gs to x.y → x->y or && → || or true → false
	'AndrewRadev/switch.vim',
	-- read and write gnupg encrypted files (.gpg,.pgp,.asc)
	'jamessan/vim-gnupg',
	{ "akinsho/toggleterm.nvim", version = '*', config = function()
		require("toggleterm").setup()
	end },
	'chrisbra/csv.vim',
	'wellle/targets.vim',
	{ 'numToStr/Comment.nvim', opts = {
		-- add any options here
		},
		lazy = false,
	},
	{ 'echasnovski/mini.nvim', config = function()
		-- ga: start alignment mode
		-- gA: start alignment mode with preview
		-- in alignment mode:
		--   s: change split pattern
		--   j: change justification
		--   m: change merge delimiter
		--   =: enhanced setup for '='
		--   ,: enhanced setup for ','
		--   <Space>: enhanced setup for ' '
		--   pre-steps:
		--   f: filter parts
		--   i: ignore some split matches
		--   p: pair parts
		--   t: trim parts
		--   <BS>: delete some pre-steps
		--
		require('mini.align').setup()
		require('mini.bracketed').setup {
			-- First-level elements are tables describing behavior of a target:
			--
			-- - <suffix> - single character suffix. Used after `[` / `]` in mappings.
			--   For example, with `b` creates `[B`, `[b`, `]b`, `]B` mappings.
			--   Supply empty string `''` to not create mappings.
			--
			-- - <options> - table overriding target options.
			--
			-- See `:h MiniBracketed.config` for more info.
			buffer     = { suffix = 'b', options = {} },
			comment    = { suffix = '', options = {} },  -- disabled because 'c' would collide with gitgutter mapping (go to next change)
			conflict   = { suffix = 'x', options = {} },
			diagnostic = { suffix = 'd', options = {} },
			file       = { suffix = 'f', options = {} },
			indent     = { suffix = 'i', options = {} },
			jump       = { suffix = 'j', options = {} },
			location   = { suffix = 'l', options = {} },
			oldfile    = { suffix = 'o', options = {} },
			quickfix   = { suffix = 'q', options = {} },
			treesitter = { suffix = 't', options = {} },
			undo       = { suffix = 'u', options = {} },
			window     = { suffix = 'w', options = {} },
			yank       = { suffix = 'y', options = {} },
		}
	end },
	'Raimondi/delimitMate',
	'PProvost/vim-ps1',
	{ 'bronson/vim-trailing-whitespace', init = function()
		-- list of file types that shall be ignored by this plugin
		vim.g.extra_whitespace_ignored_filetypes = { 'fzf' }
	end },
	'PotatoesMaster/i3-vim-syntax',
	-- ga: print unicode value of character under the cursor
	'tpope/vim-characterize',
	-- color scheme
	{ 'ishan9299/nvim-solarized-lua', config = function() vim.cmd('colorscheme solarized') end, },
	-- use :MarkdownPreview to render markdown files in the browser
	{ 'iamcco/markdown-preview.nvim',
		build = function() vim.fn['mkdp#util#install']() end,
		-- to prevent losing connection between browser tab and markdown window in
		-- neovim (see https://github.com/iamcco/markdown-preview.nvim/issues/107)
		config = function()
			vim.g.mkdp_auto_close = false
			vim.g.mkdp_preview_options = {
				uml = {
					server = 'http://telford.vic.site:8080'
				}
			}
			-- make the server visible in the network
			vim.g.mkdp_open_to_the_world = 1
	end, },
	-- <leader> dd start debugging with gdb
	-- <leader> dp start debugging python
	-- F8 :GdbBreakpointToggle
	-- F5 :GdbContinue
	-- F10 :GdbNext
	-- F11 :GdbStep
	-- F12 :GdbFinish
	-- <C-p> :GdbFrameUp
	-- <C-n> :GdbFrameDown
	-- TODO have a look at https://github.com/mechatroner/minimal_gdb to persist
	-- breakpoints
	{ 'sakhnik/nvim-gdb', build = './install.sh' },
	-- Entering a text window in Firefox will immediately start an instance of
	-- Neovim in an overlay window.
	-- :w - put content of buffer into the text window
	-- :q - close the Neovim overlay
	-- <C-e> - open Neovim overlay in current text window manually
	{ 'glacambre/firenvim',
		-- Lazy load firenvim
		-- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
		lazy = not vim.g.started_by_firenvim,
		build = function() vim.fn['firenvim#install'](0) end,
		config = function()
			if vim.g.started_by_firenvim then
				vim.api.nvim_create_autocmd('BufEnter', {desc = 'Generally use Markdown syntax',
														 pattern = '*.txt',
														 callback = function() vim.opt.filetype = 'markdown' end, })
				-- specialize here for certain pages (URL is always first part of file name)
				vim.api.nvim_create_autocmd('BufEnter', {desc = 'Redmine uses textile format',
														 pattern = '*redmine*.txt',
														 callback = function() vim.opt.filetype = 'textile'
																			   vim.opt.textwidth = 0
																	end, })
				vim.api.nvim_create_autocmd('BufEnter', {desc = 'using Twiki syntax file and configuration suggested by https://twiki.org/cgi-bin/view/Codev/VimEditor',
														 pattern = 'twiki*.txt',
														 callback = function() vim.opt.filetype = 'twiki'
																			   vim.opt.expandtab = true
																			   vim.opt.softtabstop = 3
																			   vim.opt.tabstop = 8
																			   vim.opt.shiftwidth = 3
																			   vim.opt.textwidth = 0
																	end, })
				vim.api.nvim_create_autocmd('BufEnter', {desc = 'Jupyter notebook, Python',
														 pattern = '*ipynb_er-DIV*.txt',
														 callback = function() vim.opt.filetype = 'python'
																			   vim.keymap.set('n', '<CR>', function()
																				   vim.cmd.write {}
																				   vim.cmd.call { 'firenvim#press_keys(\"<LT>C-CR>\")<CR>' }
																			   end, {noremap = true})
																	end, })
				vim.api.nvim_create_autocmd('BufEnter', {desc = 'Jupyter notebook, Octave',
														 pattern = '*ipynb_er-DIV*.txt',
														 callback = function() vim.opt.filetype = 'octave'
																			   vim.keymap.set('n', '<CR>', function()
																				   vim.cmd.write {}
																				   vim.cmd.call { 'firenvim#press_keys(\"<LT>C-CR>\")<CR>' }
																			   end, {noremap = true})
																	end, })
				vim.api.nvim_create_autocmd('BufEnter', {desc = 'Jupyter notebook, Text',
														 pattern = '*ipynb_ontainer-DIV*.txt',
														 callback = function() vim.opt.filetype = 'markdown' end, })
				vim.api.nvim_create_autocmd('BufEnter', {desc = 'Chat pages: Enter sends the message and deletes the buffer. Shift Enter is normal return. Insert mode is default.',
														 pattern = { '*slack.com*', '*gitter.im*', '*element.io*', '*discord.com*' },
														 callback = function() vim.opt.filetype = 'markdown'
																			   vim.keymap.set('i', '<CR>', function()
																				   vim.cmd.call { '<Esc>' }
																				   vim.cmd.write {}
																				   vim.cmd.call { 'firenvim#press_keys(\"<LT>CR>\")<CR>ggdGa' }
																			   end, {noremap = true})
																			   vim.keymap.set('i', '<s-CR>', '<CR>', {noremap = true})
																			   vim.opt.textwidth = 0
																			   vim.opt.laststatus = 0
																			   require'treesitter-context'.disable()
																	end, })
				vim.api.nvim_create_autocmd('BufEnter', {desc = 'Compiler explorer',
														 pattern = 'godbolt.org_*.txt',
														 callback = function() vim.opt.filetype = 'cpp' end, })
			end
	end},
	-- Whenever cursor jumps some distance or moves between windows, it will flash
	-- so you can see where it is.
	-- There is a bug when closing buffers created by Fugitive's :Gdiff, therefore
	-- ignoring those buffers for now.
	{'danilamihailov/beacon.nvim',
		init = function() vim.g.beacon_ignore_buffers = { "[Git]" } end,
		opts = {
			winblend = 70,
			highlight = {bg = 'white', ctermbg = 15},
		},
	},
	-- Statistics about your keystrokes
	'aldevv/vim-apm',
	-- Configuration for most commonly used language servers
	-- :LspInfo shows the status of active and configured language servers
	{ 'neovim/nvim-lspconfig',
	 dependencies = {
		-- package manager for LSP servers, DAP servers, linters and formatters
		{ "mason-org/mason.nvim", config = true },
		-- add LspInstall command and translate names between Mason and Lspconfig
		"mason-org/mason-lspconfig.nvim",
	 },
	  config = function()
		local custom_lsp_attach = function(client)
			-- See `:help nvim_buf_set_keymap()` for more information
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap = true, buffer = true, desc = 'hover'})
			vim.keymap.set('n', '<Leader>def', vim.lsp.buf.definition, {noremap = true, buffer = true, desc = 'goto definition'})
			vim.keymap.set('n', '<Leader>type', vim.lsp.buf.type_definition, {noremap = true, buffer = true, desc = 'goto type definition'})
			-- vim.keymap.set('n', '<Leader>imp', vim.lsp.buf.implementation, {noremap = true, buffer = true, desc = 'goto implementation'}) -- this is now `gri` per neovim's defaults
			vim.keymap.set('n', '<Leader>ref', vim.lsp.buf.rename, {noremap = true, buffer = true, desc = 'rename'})
			vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, {noremap = true, buffer = true, desc = 'code action'})
			vim.keymap.set('n', '<Leader>format', vim.lsp.buf.format, {noremap = true, buffer = true, desc = 'format'})
			vim.keymap.set('n', '<Leader>dn', vim.diagnostic.goto_next, {noremap = true, buffer = true, desc = 'goto next diagnostic'})
			vim.keymap.set('n', '<Leader>dp', vim.diagnostic.goto_prev, {noremap = true, buffer = true, desc = 'goto previous diagnostic'})
			vim.keymap.set('n', '<Leader>dsb', function() return vim.diagnostic.open_float({scope='buffer'}) end, {noremap = true, buffer = true, desc = 'open diagnostics for buffer in floating window'})
			vim.keymap.set('n', '<Leader>dsc', function() return vim.diagnostic.open_float({scope='cursor'}) end, {noremap = true, buffer = true, desc = 'open diagnostics for cursor in floating window'})
			vim.keymap.set('n', '<Leader>dsl', function() return vim.diagnostic.open_float({scope='line'}) end, {noremap = true, buffer = true, desc = 'open diagnostics for line in floating buffer'})
			-- Use LSP as the handler for omnifunc.
			--    See `:help omnifunc` and `:help ins-completion` for more information.
			vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
			-- TODO use client.supports_method(<method>) instead of `server_capabilities` (see nvim v0.10.0 Changelog: https://neovim.io/doc/user/news-0.10.html)
			-- Do not use Pyright for renaming, because LSP server (pylsp) is doing that already, otherwise renaming would be triggered twice in Python files.
			if client.name == 'pyright' then
				client.server_capabilities.renameProvider = false
			end
			-- For plugins with an `on_attach` callback, call them here. For example:
			-- require('completion').on_attach()
			-- from https://github.com/justinmk/config/commit/c0d5457f05056bf978dc4c8541091c77879fcf43
			vim.keymap.set('n', 'gK', function(ev)
				if vim.v.count > 0 then
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
				else
					-- vim.diagnostic.open_float()
					vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
				end
			end, { buffer = 0, desc = 'Toggle verbose diagnostics. Toggle inlay_hint with [count].' })
		end
		-- more refined capabilities for nvim-cmp to be able to provide more completion candidates
		local cmp_nvim_lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
		vim.lsp.config('*', {
			-- capabilities are merged with the language server capabilities
			capabilities = cmp_nvim_lsp_capabilities,
		})
		-- perform actions after the default `on_attach` actions are performed
		vim.api.nvim_create_autocmd('LspAttach', {
			callback = custom_lsp_attach
		})
		vim.lsp.enable('julials')
		vim.lsp.enable('lua_ls')
		vim.lsp.config.clangd = {
			cmd = {
				'clangd',
				--'--log=verbose',
				'--background-index',
				'--suggest-missing-includes',
				'--clang-tidy',
				'--pretty',
				'--rename-file-limit=0',
			},
		}
		vim.lsp.enable('clangd')
		vim.lsp.enable('julials')
		vim.lsp.enable('pyright')
		vim.lsp.config('pylsp', {
			on_attach = custom_lsp_attach,
			settings = {
				pylsp = {
					plugins = {
						black = {
							enabled = true
						},
						pylint = {
							enabled = true
						},
					}
				}
			}
		})
		vim.lsp.enable('pylsp')
		-- LTeX can be downloaded here: https://github.com/valentjn/ltex-ls/releases/
		local path_de = vim.fn.stdpath("config") .. "/spell/de.utf-8.add"
		local words_de = {}
		for word in io.open(path_de, "r"):lines() do
			table.insert(words_de, word)
		end
		local path_en = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
		local words_en = {}
		for word in io.open(path_en, "r"):lines() do
			table.insert(words_en, word)
		end
		vim.lsp.config.ltex = {
			filetypes = { 'plaintex', 'tex' },
			settings = {ltex = {dictionary = {
				['de'] = words_de,
				['en'] = words_en,
			}}}
		}
		vim.lsp.enable('ltex')
		vim.lsp.config.texlab = {
			settings = {
				args = {"-auxdir=aux_texlab", "outdir=pdf_texlab"}, -- should all be specified in the .latexmkrc
				auxDirectory = "aux_texlab",
				pdfDirectory = "pdf_texlab",
			}
		}
		vim.lsp.enable('texlab')
		vim.lsp.config.yamlls = {
			filetypes = { '*yaml*' },
		}
		vim.lsp.enable('yamlls')
	end },
	{ 'dense-analysis/ale', config = function()
		vim.g.ale_use_neovim_diagnostics_api = 1
		vim.g.ale_disable_lsp = 1  -- using LSP directly
		vim.g.ale_linters_ignore = {
			-- these are normally covered by clangd via LSP (given the flag `--clang-tidy` is used and depending on the .clang-tidy config file)
			c = {'cc', 'clangtidy', 'clangcheck'},
			cpp = {'cc', 'clangtidy', 'clangcheck'},
			python = {'pylint', -- provided py pylsp
					  'flake8'}, -- pylint/pylsp contains everything from flake8
		}
		vim.g.ale_linters = {
			matlab = {'mlint', 'mh_lint', 'mh_style'},
		}
	end },
	{ "chrisgrieser/nvim-rulebook",
		keys = {
			{ "<leader>i", function() require("rulebook").ignoreRule() end, desc = "Add command to ignore this linter rule." },
			{ "<leader>?", function() require("rulebook").lookupRule() end , desc = "Show documentation to this linter rule." },
		}
	},
	'nvim-lua/popup.nvim',
	'nvim-lua/plenary.nvim',
	{ 'nvim-telescope/telescope.nvim',
	  dependencies = { 'nvim-lua/plenary.nvim',
					   {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
					   {'kyazdani42/nvim-web-devicons', lazy = true },
					   -- use Telescope for calls to vim.ui.select
					   {'nvim-telescope/telescope-ui-select.nvim' },
				   },
	  init = function()
		require('telescope').load_extension('fzf')
		require("telescope").load_extension("ui-select")
	  	vim.keymap.set(
	  		'n', '<Leader>dt', function() return require('telescope.builtin').diagnostics() end,
	  		{ noremap = true, desc = 'open all diagnostics with telescope' }
	  	)
		vim.keymap.set('n', '<Leader>ff', function() return require('telescope.builtin').find_files() end,
		    { noremap =true, desc = 'Telescope find_files'}
		)
		vim.keymap.set("v", "<leader>ff", function() require("telescope.builtin").find_files({
			search_file = vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"))[1], })
				end, { noremap = true, desc = 'Telescope search selected string in file names' }
		)
		vim.keymap.set('n', '<Leader>fg', ":lua require('telescope.builtin').grep_string({search = vim.fn.input('Search text: ')})<CR>",
		    { noremap =true, desc = 'Telescope search a string in files'}
		)
		vim.keymap.set('v', '<Leader>fg', function() return require('telescope.builtin').grep_string() end,
		    { noremap =true, desc = 'Telescope search selected string in files'}
		)
		vim.keymap.set("n", "<leader>fwf", function() require("telescope.builtin").find_files({
						search_file = vim.fn.expand("<cword>"), })
				end, { noremap = true, desc = 'Telescope search selected string in files' }
		)
		vim.keymap.set("n", "<leader>fwg", function() require("telescope.builtin").grep_string({
						search = vim.fn.expand("<cword>"), })
				end, { noremap = true, desc = 'Telescope search selected string in files' }
		)
	  	vim.keymap.set('n', '<Leader>fm', ':Telescope keymaps<CR>')
		vim.keymap.set('n', '<Leader>fr', function() return require('telescope.builtin').resume() end,
			{ noremap = true, desc = 'resume last Telescope session' })
		-- vim.cmd('command! TelescopeFdUnrestricted lua require("telescope.builtin").fd({no_ignore = true,})')
		vim.api.nvim_create_user_command(
			'TelescopeFdNoignore',
			function() require("telescope.builtin").fd({no_ignore = true,}) end,
			{desc = 'do not ignore files specified in .gitignore'}
			)
	  end
	},
	{ 'danymat/neogen', config = function()
		require('neogen').setup {
			enabled = true,
		}
		vim.api.nvim_set_keymap(
			'n',
			'<Leader>gen',
			'',
			{
				noremap = true,
				callback = require('neogen').generate,
				desc = 'create documentation with Neogen',
			}
		)
	end},
	-- automatically demangle assembly files
	'ThomasFeher/nvim-demangle',

	-- Auto-completion
	'hrsh7th/cmp-nvim-lsp-signature-help',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/cmp-omni',
	{ 'saadparwaiz1/cmp_luasnip' },
	{ 'hrsh7th/nvim-cmp',
		config = function()
			-- Setup nvim-cmp.
			local cmp = require'cmp'
			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						require'luasnip'.lsp_expand(args.body)
					end,
				},
				mapping = {
					['<C-n>'] = cmp.mapping.select_next_item({ 'i', 'c'}),
					['<C-p>'] = cmp.mapping.select_prev_item({ 'i', 'c'}),
					['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
					['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
					['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
					['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
					['<C-e>'] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				},
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'path' },
					{ name = "nvim_lsp_signature_help" },
					{ name = 'luasnip' },
					{ name = 'omni' },
					}, {
						{ name = 'buffer' },
				})
			})
			-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline('/', {
				sources = {
					{ name = 'buffer' }
				}
			})
			-- configure auto-completion with nvim-cmp
			vim.opt.completeopt={"menu", "menuone", "noselect"}
		end
	},
	-- add information to current search
	{ 'kevinhwang91/nvim-hlslens',
		config = function()
			local kopts = {noremap = true, silent = true}
			vim.api.nvim_set_keymap('n', 'n',
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
			kopts)
			vim.api.nvim_set_keymap('n', 'N',
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
			kopts)
			vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
		end
	},
	-- add a scrollbar that shows locations of diagnostics and search results
	{ 'petertriho/nvim-scrollbar',
		config = function()
			require("scrollbar").setup()
			require("scrollbar.handlers.search").setup()
		end
	},
	{ 'nvim-lualine/lualine.nvim',
		dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true },
		config = function() require('lualine').setup{
			options = { theme  = 'solarized_dark' },
			sections = { lualine_c = { { 'filename', path = 1 } } },
				}
			end,
	},
	-- display file name for each window at the top right via virtual text
	{ 'b0o/incline.nvim',
		config = function()
			require('incline').setup {
				hide = {
					focused_win = true,
				}
			}
		end
	},
	-- improved switching between windows
	{ 'https://gitlab.com/yorickpeterse/nvim-window.git',
		config = function()
			vim.api.nvim_set_keymap('n', '<silent> <leader>W', '',  {
				noremap = true,
				callback = require('nvim-window').pick,
				desc = 'navigate buffers with nvim-window',
			})
		end
	},

	-- interacting with compiler-explorer
	-- https://github.com/krady21/compiler-explorer.nvim
    -- CECompile
    -- CECompileLive
    -- CEFormat
    -- CEAddLibrary
    -- CELoadExample
    -- CEOpenWebsite
    -- CEShowTooltip (local to assembly buffer)
    -- CEGotoLabel (local to assembly buffer)
	{ 'krady21/compiler-explorer.nvim' },
	-- quickly switch python virtual environments from within neovim without restarting
	-- https://github.com/AckslD/swenv.nvim
	-- require('swenv.api').pick_venv()
	{ 'AckslD/swenv.nvim' },
	-- Local config file with confirmation
	-- https://github.com/MunifTanjim/exrc.nvim
	-- :ExrcSource
	{ 'MunifTanjim/exrc.nvim' },
	-- Intelligently reopen files at your last edit position in Vim.
	-- Handles more edge-cases than the code listed in `:help last-position-jump`
	{ 'farmergreg/vim-lastplace' },
	{ 'ThomasFeher/broot.nvim',
		dependencies = 'rbgrouleff/bclose.vim',
		branch = 'fixes',
	},
	-- show colorcolumn depending on actual length of the line
    { 'Bekaboo/deadcolumn.nvim' },
	{ "mfussenegger/nvim-dap",
		keys = {
			{"gdebug", "<cmd>DapNew<cr>", desc = "Start a new debugging session."},
		},
	},
	{ "rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = true,
		init = function()
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
	-- use lldb via CodeLLDB extension (install via Mason)
	-- { "julianolf/nvim-dap-lldb", dependencies = { "mfussenegger/nvim-dap" }, },
	{ "jay-babu/mason-nvim-dap.nvim",
		dependencies = { "mfussenegger/nvim-dap", "mason-org/mason.nvim"},
		opts = {
			ensure_installed = { "cppdbg", "codelldb", "python" },
			handlers = {
				function(config)
					-- all sources with no handler get passed here

					-- Keep original functionality
					require('mason-nvim-dap').default_setup(config)
				end,
				cppdbg = function(config)
						config.configurations = {
							{
								name = "(gdb) attach",
								type = "cppdbg",
								request = "attach",
								cwd = "${workspaceFolder}",
								processId = "${command:pickProcess}",
								program = "${command:pickFile}",
								stopAtEntry = false,
								setupCommands = {
									{
										text = "-enable-pretty-printing",
										description = "enable pretty printing",
										ignoreFailures = false,
									},
								},
							},
						}
					-- merge with defaults
					vim.list_extend(config.configurations, require('mason-nvim-dap.mappings.configurations').cppdbg)
					-- add the configuration to the corresponding filetypes
					require('mason-nvim-dap').default_setup(config)
				end,
			},
		},
		config = true,
 	},
	{ 'theHamsta/nvim-dap-virtual-text', config = true, },
	-- this is not working, but would be a good starting point for implementing a dap mode
	{ 'JGStyle/nvim-dap-mode'},
	-- practice touch typing
	{
		"nvzone/typr",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = { "Typr", "TyprStats" },
	}
},
	{
		git = {
			-- do full checkouts on plugin repositories, because we might want to do changes
			depth = nil }
		}
)
