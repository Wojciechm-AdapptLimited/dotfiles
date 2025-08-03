-- Catppuccin theme config

return {
	"catppuccin/nvim",
	name = "catppuccin",
	branch = "main",
	config = function()
		require("catppuccin").setup({
			flavour = "auto",
			float = {
				transparent = true,
			},
			integrations = {
				blink_cmp = {
					style = "bordered",
				},
				gitsigns = true,
				mason = true,
				mini = {
					enabled = true,
				},
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
						ok = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				telescope = {
					enabled = true,
				},
				treesitter = true,
				which_key = true,
			},
		})

		vim.cmd.colorscheme("catppuccin-" .. vim.g.config.themeflavour)
	end,
}
