vim.keymap.set('n', '<CR>', function()
	local status_win = vim.api.nvim_get_current_win()
	vim.cmd.normal(vim.keycode('<Plug>fugitive:<CR>'))
	if vim.api.nvim_get_current_win() ~= status_win then
		vim.api.nvim_win_close(status_win, false)
	end
end, { buffer = 0, nowait = true })
