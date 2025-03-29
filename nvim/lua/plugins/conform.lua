-- Autoformat

return {
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		format_on_save = {
			timeout_ms = 1500,
			lsp_fallback = true,
		},
		formatters_by_ft = vim.g.config.tools.formatters,
	},
}
