return {
	"lewis6991/hover.nvim",
	branch = "main",
	config = function()
		local hover = require("hover")

		hover.setup({
			init = function()
				-- Require providers
				require("hover.providers.lsp")
				require("hover.providers.diagnostic")
				require("hover.providers.fold_preview")
			end,
			preview_opts = {
				border = "single",
				max_width = 100,
			},
			title = true,
			mouse_providers = {
				"LSP",
			},
			mouse_delay = 1000,
		})
		-- Opens a popup that displays documentation about the word under your cursor
		--  See `:help K` for why this keymap
		vim.keymap.set("n", "K", hover.hover, { desc = "Hover Documentation" })

		-- Mouse support
		vim.keymap.set("n", "<MouseMove>", hover.hover_mouse, {})
	end,
}
