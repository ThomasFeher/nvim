vim.g.mapleader = 'ß'
vim.g.maplocalleader = 'ß'
vim.g.load_doxygen_syntax = true

vim.opt.breakindent = true -- better indentation for soft wrapping
vim.opt.background = 'dark'
vim.opt.colorcolumn = { 81 } -- highlight overlength column
vim.opt.cursorcolumn = true -- highlight current column
vim.opt.cursorline = true -- highlight current line
vim.opt.diffopt = { 'filler', 'vertical' }
vim.opt.history = 50 -- keep 50 lines of command line history
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.inccommand = 'split' -- show result of substitution in separate split window
vim.opt.incsearch = true -- do incremental searching
vim.opt.laststatus = 3 -- only a single global status line
vim.opt.number = true -- But show the actual number for the line we're on
vim.opt.pumblend = 10 -- make popup-menu semi-transparent
vim.opt.relativenumber = true -- Show line numbers
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 4
vim.opt.signcolumn = 'auto:9'
vim.opt.showcmd = true -- display incomplete commands
vim.opt.smartcase = true -- Don't ignore case when there is a capital letter in the query
vim.opt.spelloptions = 'camel' -- each part of came-case words is spell-checked individually
vim.opt.splitright = true -- Prefer windows splitting to the right
vim.opt.splitbelow = true -- Prefer windows splitting to the bottom
vim.opt.startofline = false -- preserve cursor column
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.wildmode = { 'longest', 'full' }
vim.opt.winblend = 10 -- make floating windows semi-transparent

-- load plugins
require'plugins'

vim.api.nvim_set_keymap('n', 'ö', ':w<CR>', {noremap = true})

-- Quickly edit/reload the vimrc file
vim.api.nvim_set_keymap('n', '<leader>ev', ':e $MYVIMRC<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>sv',  ':so $MYVIMRC<CR>', {noremap = true})

-- navigate between windows
vim.api.nvim_set_keymap('n', '<leader><left>', '<C-W>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader><right>', '<C-W>l', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader><up>', '<C-W>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader><down>', '<C-W>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader><home>', '0<C-W>w', {noremap = true})
-- navigate out of terminal mode
vim.api.nvim_set_keymap('t', '<leader><left>', '<C-\\><C-N><C-W>h', {noremap = true})
vim.api.nvim_set_keymap('t', '<leader><right>', '<C-\\><C-N><C-W>l', {noremap = true})
vim.api.nvim_set_keymap('t', '<leader><up>', '<C-\\><C-N><C-W>k', {noremap = true})
vim.api.nvim_set_keymap('t', '<leader><down>', '<C-\\><C-N><C-W>j', {noremap = true})
-- tag navigation (view tag list with :tags)
--   jump to tag (using 'K' seems better, because more generic)
vim.keymap.set('n', '<leader><CR>', '<C-]>', {noremap = true})
--   back to last jump position
vim.keymap.set('n', '<leader><insert>', '<C-T>', {noremap = true})
-- fold navigation
vim.keymap.set('n', 'z<up>', 'zk', {noremap = true})
vim.keymap.set('n', 'z<down>', 'zj', {noremap = true})
-- make popup menu usable via arrow keys
-- TODO comment out, try to work without it
--vim.keymap.set('c', '<Up>', function()
		--if vim.fn.pumvisible() then
			--return '<C-p>'
		--else
			--return '<Up>'
		--end
	--end,
	--{noremap = true,
	 --expr = true,})
--vim.keymap.set('c', '<Down>', function()
		--if vim.fn.pumvisible() then
			--return '<C-n>'
		--else
			--return '<Down>'
		--end
	--end,
	--{noremap = true,
	 --expr = true,})
--vim.keymap.set('c', '<Left>', function()
		--if vim.fn.pumvisible() then
			--return '<Up>'
		--else
			--return '<Left>'
		--end
	--end,
	--{noremap = true,
	 --expr = true,})
--vim.keymap.set('c', '<Right>', function()
		--if vim.fn.pumvisible() then
			--return '<Down>'
		--else
			--return '<Right>'
		--end
	--end,
	--{noremap = true,
	 --expr = true,})

vim.api.nvim_create_augroup('uml', {})
vim.api.nvim_create_autocmd('BufWritePost', { desc = 'Generate PlantUML diagrams after writing the file',
	                                          pattern = {'*.plantuml', '*.pu', '*.puml', '*.uml'},
                                              group = 'uml',
	                                          -- untested
                                              callback = function(data) io.popen('plantuml -tsvg ' .. data.file )
                                                                        io.popen('plantuml -tsvg ' .. data.file )
	end })
vim.api.nvim_create_autocmd('TextYankPost', { desc = 'highlight yanked region',
                                              pattern = {'*'},
                                              callback = function() vim.highlight.on_yank() end, })

-- commands for changing directory to current file's directory
vim.cmd('command! CdFile cd %:p:h')
vim.cmd('command! LcdFile lcd %:p:h')

-- command for building neovim from source
vim.cmd('command! MakeNeovim make "CMAKE_INSTALL_PREFIX=$HOME/bin/neovim" "CMAKE_BUILD_TYPE=RelWithDebInfo"')
