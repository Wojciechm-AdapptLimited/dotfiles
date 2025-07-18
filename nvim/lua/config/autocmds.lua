local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("TextYankPost", {
	desc = "Highlight text when yanking (copying)",
	group = augroup("HighlightYank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

autocmd("BufWritePre", {
	desc = "Remove all training whitespace on save",
	group = augroup("TrimWhitespace", { clear = true }),
	command = [[:%s/\s·$//e]],
})

autocmd("BufEnter", {
	desc = "Disable the new line comment",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

autocmd({ "BufRead", "BufNewFile" }, {
	desc = "Enable spell checking for selected file types",
	pattern = {
		"*.txt",
		"*.md",
		"*.tex",
	},
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = "en,pl"
	end,
})

autocmd("BufReadPost", {
	desc = "Go to the last location after opening a buffer",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)

		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

local cursor_grp = augroup("CursorLine", { clear = true })
autocmd({ "InsertLeave", "WinEnter" }, {
	desc = "Show cursor line in the active window",
	command = "set cursorline",
	group = cursor_grp,
})
autocmd({ "InsertEnter", "WinLeave" }, {
	desc = "Hide cursor line in inactive windows",
	command = "set nocursorline",
	group = cursor_grp,
})
