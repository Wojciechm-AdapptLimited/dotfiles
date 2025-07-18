-- Autocompletion

return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		-- Snippet Engine
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
	},
	opts = {
		keymap = {
			-- 'default' (recommended) for mappings similar to built-in completions
			--   <c-y> to accept ([y]es) the completion.
			--    This will auto-import if your LSP supports it.
			--    This will expand snippets if the LSP sent a snippet.
			-- 'super-tab' for tab to accept
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- For an understanding of why the 'default' preset is recommended,
			-- you will need to read `:help ins-completion`
			--
			-- No, but seriously. Please read `:help ins-completion`, it is really good!
			--
			-- All presets have the following mappings:
			-- <tab>/<s-tab>: move to right/left of your snippet expansion
			-- <c-space>: Open menu or open docs if already open
			-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
			-- <c-e>: Hide menu
			-- <c-k>: Toggle signature help
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			preset = "default",

			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = { auto_show = true },
			list = {
				selection = {
					preselect = true,
					auto_insert = false,
				},
			},
			ghost_text = {
				enabled = true,
				-- Show the ghost text when an item has been selected
				show_with_selection = true,
				-- Show the ghost text when no item has been selected, defaulting to the first item
				show_without_selection = false,
				-- Show the ghost text when the menu is open
				show_with_menu = true,
				-- Show the ghost text when the menu is closed
				show_without_menu = true,
			},
		},

		sources = {
			default = { "lsp", "buffer", "snippets", "path" },
		},

		signature = { enabled = true },
	},
	opts_extend = { "sources.default" },
}
