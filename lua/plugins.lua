local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end
-- recompile this file whenever it was changed
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

vim.api.nvim_set_keymap('n', 'ä', ']', {})
vim.api.nvim_set_keymap('n', 'ü', '[', {})

return require('packer').startup({function(use)
	use 'wbthomason/packer.nvim'

	use { 'lervag/vimtex', config = function()
			vim.g.tex_flavor = 'latex'
			vim.g.vimtex_fold_enabled = 0 -- actvated folding slowes neovim down significantly
			vim.g.vimtex_view_general_viewer = 'okular'
			vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'
			vim.g.vimtex_compiler_latexmk = { build_dir = 'build' }
			vim.g.vimtex_syntax_enabled = 0  -- using treesitter for syntax highlighting
			vim.g.vimtex_syntax_conceal_disable = 1  -- no conceal available when using treesitter
		end,
		}

	-- Snippets
	use 'SirVer/ultisnips'
	use 'honza/vim-snippets'

	-- Git integration
	use { 'tpope/vim-fugitive', config = function()
		vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', {noremap = true})
		end,
	}
	-- Git tree viewer
	-- g? in tree view to see mappings
	-- '@ jump to current HEAD
	use { 'rbong/vim-flog' }
	use { 'airblade/vim-gitgutter' }
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
	use 'rhysd/git-messenger.vim'

	-- File handling
	--   -: enter file explorer
	--   s: change sorting
	--   I: change to old view
	use 'tpope/vim-vinegar'
	--   :Chmod
	--   :Copy
	--   :Mkdir
	--   :Move
	--   :Remove
	--   :SudoEdit
	--   and more
	use 'tpope/vim-eunuch'

	use { 'vimwiki/vimwiki',  branch = 'dev', config = function()
			-- use vimwiki for markdown files
			vim.g.vimwiki_ext2syntax = { ['.md'] = 'markdown', ['.mkd'] = 'markdown', ['.wiki'] = 'media' }
			-- make vimwikis default syntax markdown
			vim.g.vimwiki_list = { {path = '~/vimwiki', syntax = 'markdown', ext = '.md'} }
			vim.g.vimwiki_markdown_link_ext = 1
			-- remove mapping that shadows automatic indentation (==) which is not needed
			-- in vimwiki, but sometimes we need to switch vimwiki files that are initially
			-- of type vimwiki to another filetype where automatic indentation is needed,
			-- especially in firenvim
			vim.keymap.set('n', '<Nop>', '<Plug>VimwikiAddHeaderLevel')
			-- remove mapping that shadows vim-vinegars mapping to enter file browsing
			vim.keymap.set('n', '<Nop>', '<Plug>VimwikiRemoveHeaderLevel')
			vim.keymap.set('n', '<CR>', '<Plug>VimwikiFollowLink')
		end,
	}

	-- Tree-sitter
	-- language parser for better syntax highlighting, refactoring, navigation,
	-- text objects, folding and more
	use { 'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require'nvim-treesitter.configs'.setup {
				ensure_installed = "c", "cpp",     -- one of "all", "language", or a list of languages
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
		end
	}
	use 'nvim-treesitter/nvim-treesitter-refactor'
	use 'nvim-treesitter/nvim-treesitter-textobjects'
	use 'nvim-treesitter/playground'
	-- use { 'nvim-treesitter/nvim-treesitter-context'}
	use { 'nvim-treesitter/nvim-treesitter-context',
		config = require'treesitter-context'.setup {
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
	}

	-- Modify quickfix (and location list) entries, writing these modifications will modify the original parts
	use 'stefandtw/quickfix-reflector.vim'
	use 'vim-scripts/TWiki-Syntax'
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
	use { 'junegunn/fzf', run = 'fzf#install()' }
	use { 'junegunn/fzf.vim', requires = 'junegunn/fzf', config = function()
		-- use floating window for FZF
		vim.g.fzf_layout = { window = { width = 0.8, height = 0.5, highlight = 'Comment' } }
		vim.keymap.set('n', '<Leader>fzf', ':FZF "--preview"')
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
	end }
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
	use { 'andymass/vim-matchup', config = function()
		-- does in more situations the correct thing that `autocmd FileType cpp setlocal matchpairs+=<:>`
		vim.g.matchup_matchpref = {cpp = {template = 1}}
	end }
	-- Zeal for vim
	-- <leader>z on a word to search it in zeal (alternative :Zeavim or :ZeamvimV)
	use 'KabbAmine/zeavim.vim'
	-- automatically highlighting other uses of the current word under the cursor
	use 'RRethy/vim-illuminate'
	-- Diff two blocks in the same file
	-- mark first block and do :Linediff
	-- mark second block and do :Linediff
	-- exit diff view with :LinediffReset
	use 'AndrewRadev/linediff.vim'
	use 'editorconfig/editorconfig-vim'
	-- Integration of https://github.com/BobBuildTool/bob into Neovim
	use { 'ThomasFeher/vim-bob' , config = function()
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
	end}
	-- syntax highlighting for PlantUML
	-- The filetype will be set to plantuml for *.pu, *.uml or *.plantuml files or
	-- if the first line of a file contains @startuml.
	-- Additionally the makeprg is set to plantuml.
	use 'aklt/plantuml-syntax'
	-- fold python functions and classes
	use 'tmhedberg/SimpylFold'
	-- edit surrounding tags, quotes, etc.
	-- cs"': change next surrounding double quotes to single quotes
	-- ysiw": add ("yank") double quotes around current word
	-- ds': delete next surrounding single quotes
	use 'tpope/vim-surround'
	-- dot command repeats plugin mappings, too, if supported by the plugin (e.g.
	-- vim-surround)
	use 'tpope/vim-repeat'
	-- diff viewer on directory level
	-- :DirDiff <dir1> <dir2>
	use 'will133/vim-dirdiff'
	-- press gS to split expressions on multiple lines
	-- press gJ to join multiline expressions on one line
	use 'AndrewRadev/splitjoin.vim'
	-- press gs to x.y → x->y or && → || or true → false
	use 'AndrewRadev/switch.vim'
	-- read and write gnupg encrypted files (.gpg,.pgp,.asc)
	use 'jamessan/vim-gnupg'
	use { "akinsho/toggleterm.nvim", tag = '*', config = function()
		require("toggleterm").setup()
	end }
	use 'chrisbra/csv.vim'
	use 'wellle/targets.vim'
	use { 'echasnovski/mini.nvim', config = function()
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
		require('mini.comment').setup{
			mappings = {
				-- Toggle comment (like `gcip` - comment inner paragraph) for both
				-- Normal and Visual modes
				comment = 'gc',
				-- Toggle comment on current line
				comment_line = 'gcc',
				-- Define 'comment' textobject (like `dgc` - delete whole comment block)
				textobject = 'gc',
			},
		}
	end }
	use 'Raimondi/delimitMate'
	use 'PProvost/vim-ps1'
	use { 'bronson/vim-trailing-whitespace', setup = function()
		-- list of file types that shall be ignored by this plugin
		vim.g.extra_whitespace_ignored_filetypes = { 'fzf' }
	end }
	use 'PotatoesMaster/i3-vim-syntax'
	-- ga: print unicode value of character under the cursor
	use 'tpope/vim-characterize'
	-- color scheme
	use { 'ishan9299/nvim-solarized-lua', config = function() vim.cmd('colorscheme solarized') end, }
	-- use :MarkdownPreview to render markdown files in the browser
	use { 'iamcco/markdown-preview.nvim',
		run = function() fn['mkdp#util#install']() end,
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
	end, }
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
	use { 'sakhnik/nvim-gdb', run = './install.sh' }
	-- Entering a text window in Firefox will immediately start an instance of
	-- Neovim in an overlay window.
	-- :w - put content of buffer into the text window
	-- :q - close the Neovim overlay
	-- <C-e> - open Neovim overlay in current text window manually
	use { 'glacambre/firenvim',
		run = function() fn['firenvim#install'](0) end,
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
	end}
	-- Whenever cursor jumps some distance or moves between windows, it will flash
	-- so you can see where it is.
	-- There is a bug when closing buffers created by Fugitive's :Gdiff, therefore
	-- ignoring those buffers for now.
	use 'danilamihailov/beacon.nvim'
	vim.g.beacon_ignore_buffers = { "[Git]" }
	-- Statistics about your keystrokes
	use 'ThePrimeagen/vim-apm'
	-- Configuration for most commonly used language servers
	-- :LspInfo shows the status of active and configured language servers
	use { 'neovim/nvim-lspconfig', config = function()
		local custom_lsp_attach = function(client)
			-- See `:help nvim_buf_set_keymap()` for more information
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap = true, buffer = true})
			vim.keymap.set('n', '<Leader>def', vim.lsp.buf.definition, {noremap = true, buffer = true})
			vim.keymap.set('n', '<Leader>type', vim.lsp.buf.type_definition, {noremap = true, buffer = true})
			vim.keymap.set('n', '<Leader>imp', vim.lsp.buf.implementation, {noremap = true, buffer = true})
			vim.keymap.set('n', '<Leader>ref', vim.lsp.buf.rename, {noremap = true, buffer = true})
			vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, {noremap = true, buffer = true})
			vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, {noremap = true, buffer = true})
			vim.keymap.set('n', '<Leader>dn', vim.diagnostic.goto_next, {noremap = true, buffer = true})
			vim.keymap.set('n', '<Leader>dp', vim.diagnostic.goto_prev, {noremap = true, buffer = true})
			vim.keymap.set('n', '<Leader>dsb', function() return vim.diagnostic.open_float({scope='buffer'}) end, {noremap = true, buffer = true})
			vim.keymap.set('n', '<Leader>dsc', function() return vim.diagnostic.open_float({scope='cursor'}) end, {noremap = true, buffer = true})
			vim.keymap.set('n', '<Leader>dsl', function() return vim.diagnostic.open_float({scope='line'}) end, {noremap = true, buffer = true})
			vim.keymap.set('n', '<Leader>dt', function() return require('telescope.builtin').diagnostics() end, {noremap = true, buffer = true})
			-- Use LSP as the handler for omnifunc.
			--    See `:help omnifunc` and `:help ins-completion` for more information.
			vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
			-- Use LSP as the handler for formatexpr.
			--    See `:help formatexpr` for more information.
			local has_formatting = nil
			for _,v in pairs(vim.lsp.get_active_clients()) do
				if v['document_range_formatting'] then
					has_formatting = 1
				end
			end
			if has_formatting then
				vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
			end
			-- For plugins with an `on_attach` callback, call them here. For example:
			-- require('completion').on_attach()
		end
		local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
		local lspconfig = require'lspconfig'
		lspconfig.sumneko_lua.setup { -- lua-language-server
			capabilities = capabilities,
			on_attach = custom_lsp_attach,
		}
		lspconfig.clangd.setup{
			capabilities = capabilities,
			on_attach = custom_lsp_attach,
			cmd = {'clangd', '--log=verbose', '--background-index', '--suggest-missing-includes', '--clang-tidy', '--pretty'},
		}
		lspconfig.pyright.setup {
			capabilities = capabilities,
			on_attach = custom_lsp_attach,
		}
		-- LTeX can be downloaded here: https://github.com/valentjn/ltex-ls/releases/
		lspconfig.ltex.setup {
			capabilities = capabilities,
			on_attach = custom_lsp_attach,
		}
	end }
	use 'nvim-lua/popup.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use { 'danymat/neogen', config = function()
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
	end}
	-- automatically demangle assembly files
	use 'ThomasFeher/nvim-demangle'

	-- Auto-completion
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/cmp-omni'
	use 'quangnguyen30192/cmp-nvim-ultisnips'
	use { 'hrsh7th/nvim-cmp',
		config = function()
			-- Setup nvim-cmp.
			local cmp = require'cmp'
			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						vim.fn["UltiSnips#Anon"](args.body)
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
					{ name = 'ultisnips' },
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
	}
	-- add information to current search
	use { 'kevinhwang91/nvim-hlslens',
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
			vim.api.nvim_set_keymap('n', '<Leader>l', ':noh<CR>', kopts)
		end
	}
	-- add a scrollbar that shows locations of diagnostics and search results
	use { 'petertriho/nvim-scrollbar',
		config = function()
			require("scrollbar").setup()
			require("scrollbar.handlers.search").setup()
		end
	}
	use { 'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
		config = function() require('lualine').setup{ options = { theme  = 'solarized_dark' },} end,
	}
	-- display file name for each window at the top right via virtual text
	use { 'b0o/incline.nvim',
		config = function()
			require('incline').setup {
				hide = {
					focused_win = true,
				}
			}
		end
	}
	-- improved switching between windows
	use { 'https://gitlab.com/yorickpeterse/nvim-window.git',
		config = function()
			vim.api.nvim_set_keymap('n', '<silent> <leader>W', '',  {
				noremap = true,
				callback = require('nvim-window').pick,
				desc = 'navigate buffers with nvim-window',
			})
		end
	}

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
	use { 'krady21/compiler-explorer.nvim' }
	-- quickly switch python virtual environments from within neovim without restarting
	-- https://github.com/AckslD/swenv.nvim
	-- require('swenv.api').pick_venv()
	use { 'AckslD/swenv.nvim' }
	-- Local config file with confirmation
	-- https://github.com/MunifTanjim/exrc.nvim
	-- :ExrcSource
	use { 'MunifTanjim/exrc.nvim' }
	-- Intelligently reopen files at your last edit position in Vim.
	-- Handles more edge-cases than the code listed in `:help last-position-jump`
	use { 'farmergreg/vim-lastplace' }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end,
	config = {
		git = {
			-- do full checkouts on plugin repositories, because we might want to do changes
			depth = nil } }
})
