local function init()
	-- setup <space> as the map leader - must be done before loading lazy
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- load config
	vim.g.config = require("config.options")

	-- configure vim.opt
	for k, v in pairs(vim.g.config.options) do
		vim.opt[k] = v
	end

	-- auto commands
	require("config.autocmds")

	-- file type patches
	require("config.ft")

	-- lazy.nvim
	require("config.lazy")

	-- key mappings - must be done after lazy
	require("config.keymaps")
end

init()
