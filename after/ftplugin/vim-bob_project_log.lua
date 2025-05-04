vim.keymap.set('n', '<CR>', '<cmd>BobProject!<CR>', {
	desc = 'Start project that is logged under the cursor.',
	buffer = true,
})
vim.keymap.set('n', '<leader><CR>', '<cmd>BobProjectNoBuild<CR>', {
	desc = 'Start project that is logged under the cursor without re-building it.',
	buffer = true,
})
-- no need for linting a generated file
vim.cmd('ALEDisableBuffer')
