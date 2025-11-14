-- Autocompletion

return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		-- Snippet Engine
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			run = "make install_jsregexp",
			dependencies = {
				"rafamadriz/friendly-snippets",
				"giuxtaposition/blink-cmp-copilot",
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
			["<C-Enter>"] = { "select_and_accept" },

			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
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
			default = { "lsp", "buffer", "snippets", "path", "copilot" },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-cmp-copilot",
					score_offset = 100,
					async = true,
					transform_items = function(_, items)
						local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
						local kind_idx = #CompletionItemKind + 1
						CompletionItemKind[kind_idx] = "Copilot"
						for _, item in ipairs(items) do
							item.kind = kind_idx
						end
						return items
					end,
				},
				lsp = {
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					opts = {}, -- Passed to the source directly, varies by source

					--- NOTE: All of these options may be functions to get dynamic behavior
					--- See the type definitions for more information
					enabled = true, -- Whether or not to enable the provider
					async = false, -- Whether we should show the completions before this provider returns, without waiting for it
					timeout_ms = 5000, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
					transform_items = nil, -- Function to transform the items before they're returned
					should_show_items = true, -- Whether or not to show the items
					max_items = nil, -- Maximum number of items to display in the menu
					min_keyword_length = 0, -- Minimum number of characters in the keyword to trigger the provider
					-- If this provider returns 0 items, it will fallback to these providers.
					-- If multiple providers fallback to the same provider, all of the providers must return 0 items for it to fallback
					fallbacks = {},
					score_offset = 0, -- Boost/penalize the score of the items
					override = nil, -- Override the source's functions
				},
			},
		},

		signature = { enabled = true },

		appearance = {
			nerd_font_variant = "mono",
			-- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
			kind_icons = {
				Copilot = "",
				Text = "󰉿",
				Method = "󰊕",
				Function = "󰊕",
				Constructor = "󰒓",

				Field = "󰜢",
				Variable = "󰆦",
				Property = "󰖷",

				Class = "󱡠",
				Interface = "󱡠",
				Struct = "󱡠",
				Module = "󰅩",

				Unit = "󰪚",
				Value = "󰦨",
				Enum = "󰦨",
				EnumMember = "󰦨",

				Keyword = "󰻾",
				Constant = "󰏿",

				Snippet = "󱄽",
				Color = "󰏘",
				File = "󰈔",
				Reference = "󰬲",
				Folder = "󰉋",
				Event = "󱐋",
				Operator = "󰪚",
				TypeParameter = "󰬛",
			},
		},
	},
	opts_extend = { "sources.default" },
}
