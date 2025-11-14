-- Autoformat

local conf = vim.g.config

return {
	"stevearc/conform.nvim",
	dependencies = {
		-- Automatically install formatters to stdpath for neovim
		{ "williamboman/mason.nvim", branch = "main" },
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- ensure formatters are installed
		local installer = require("config.mason")
		installer.ensure_installed(conf.formatters)

		local conform = require("conform")

		conform.setup({
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 3000, lsp_format = "fallback" }
			end,
			formatters_by_ft = conf.formatters,
		})

		vim.api.nvim_create_user_command("ConformRun", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			conform.format({ async = true, lsp_format = "fallback", range = range })
		end, { range = true })
		vim.api.nvim_create_user_command("ConformDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable Conform autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("ConformEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable Conform autoformat-on-save",
		})
	end,
}
