-- Automatic Linter suplementing LSP Servers

local conf = vim.g.config

return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		-- ensure linters are installed
		local installer = require("config.mason")
		installer.ensure_installed(conf.linters)

		local lint = require("lint")

		lint.linters_by_ft = conf.linters

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "TextChanged" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
