local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

vim.api.nvim_set_keymap('n', 'ä', ']', {})
vim.api.nvim_set_keymap('n', 'ü', '[', {})

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	-- color scheme
	use 'ishan9299/nvim-solarized-lua'
	-- use :MarkdownPreview to render markdown files in the browser
	use { 'iamcco/markdown-preview.nvim', run = function() fn['mkdp#util#install']() end }
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
	use { 'glacambre/firenvim', run = function() fn['firenvim#install'](0) end }
	-- Whenever cursor jumps some distance or moves between windows, it will flash
	-- so you can see where it is.
	-- There is a bug when closing buffers created by Fugitive's :Gdiff, therefore
	-- ignoring those buffers for now.
	use 'danilamihailov/beacon.nvim'
	vim.g.beacon_ignore_buffers = { "[Git]" }
	-- Statistics about your keystrokes
	use 'ThePrimeagen/vim-apm'
	-- language parser for better syntax highlighting, refactoring, navigation,
	-- text objects, folding and more
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use 'nvim-treesitter/nvim-treesitter-refactor'
	use 'nvim-treesitter/nvim-treesitter-textobjects'
	use 'nvim-treesitter/playground'
	-- Avoid spellchecking of code for tree-sitter enabled buffers
	use 'lewis6991/spellsitter.nvim'
	use 'nvim-treesitter/nvim-treesitter-context'
	-- Configuration for most commonly used language servers
	-- :LspInfo shows the status of active and configured language servers
	use 'neovim/nvim-lspconfig'
	use 'nvim-lua/popup.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use 'danymat/neogen'

	-- Auto-completion
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
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


	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end

	require'nvim-treesitter.configs'.setup {
		ensure_installed = "c", "cpp",     -- one of "all", "language", or a list of languages
		highlight = {
			enable = true,              -- false will disable the whole extension
			disable = {},  -- list of language that will be disabled
		},
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
		indent = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = '<CR>',
				scope_incremental = '<CR>',
				node_incremental = '<TAB>',
				node_decremental = '<S-TAB>',
			},
		},
	}
	require('spellsitter').setup()
	require'treesitter-context'.setup {
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
	local custom_lsp_attach = function(client)
		-- See `:help nvim_buf_set_keymap()` for more information
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap = true, buffer = true})
		vim.keymap.set('n', '<Leader>def', vim.lsp.buf.definition, {noremap = true, buffer = true})
		vim.keymap.set('n', '<Leader>type', vim.lsp.buf.type_definition, {noremap = true, buffer = true})
		vim.keymap.set('n', '<Leader>imp', vim.lsp.buf.implementation, {noremap = true, buffer = true})
		vim.keymap.set('n', '<Leader>ref', vim.lsp.buf.rename, {noremap = true, buffer = true})
		vim.keymap.set('n', '<Leader>ac', vim.lsp.buf.code_action, {noremap = true, buffer = true})
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
		for k,v in pairs(vim.lsp.get_active_clients()) do
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
	}
	lspconfig.pyright.setup {
		capabilities = capabilities,
		on_attach = custom_lsp_attach,
	}
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
	-- configure auto-completion with nvim-cmp
	vim.opt.completeopt={"menu", "menuone", "noselect"}
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
end)
