vim.keymap.set('n', '<CR>', '<cmd>BobProject!<CR>', {
	desc = 'Start project that is logged under the cursor.',
	buffer = true,
})
vim.keymap.set('n', '<S-CR>', '<cmd>BobProjectNoBuild!<CR>', {
	desc = 'Start project that is logged under the cursor without re-building it.',
	buffer = true,
})
