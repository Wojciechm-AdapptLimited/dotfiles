-- Fuzzy Finder (files, lsp, etc)

local conf = vim.g.config

return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"jvgrootveld/telescope-zoxide",
		"nvim-telescope/telescope-ui-select.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for install instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},

		-- Useful for getting pretty icons, but requires special font.
		--  If you already have a Nerd Font, or terminal set up with fallback fonts
		--  you can enable this
		{ "nvim-tree/nvim-web-devicons" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")
		local themes = require("telescope.themes")
		local wk = require("which-key")

		telescope.setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			--
			defaults = {
				file_ignore_patterns = conf.ingnored_files,
			},
			pickers = {
				find_files = { hidden = false },
				oldfiles = { cwd_only = true },
				buffers = {
					ignore_current_buffer = true,
					sort_lastused = true,
				},
				live_grep = {
					only_sort_text = true, -- grep for content and not file name/path
					mappings = {
						i = { ["<c-f>"] = actions.to_fuzzy_refine },
					},
				},
			},
			extensions = {
				["ui-select"] = {
					themes.get_dropdown(),
				},
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
			},
		})

		-- Enable telescope extensions, if they are installed
		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")

		wk.register({
			["<leader><leader>"] = { builtin.buffers, "Existing Buffers" },
			["<leader>s"] = {
				name = "[S]earch",
				-- [S]earch Core
				f = { builtin.find_files, "[F]iles" },
				[":"] = { builtin.commands, "[:] (commands)" },
				r = { builtin.registers, "[R]egisters" },
				h = { builtin.help_tags, "[H]elp" },
				k = { builtin.keymaps, "[K]eymaps" },
				b = { builtin.builtin, "[B]uiltin" },
				d = { builtin.diagnostics, "[D]iagnostics" },
				n = {
					function()
						builtin.find_files({ cwd = vim.fn.stdpath("config") })
					end,
					"[N]eovim (config)",
				},
				s = {
					-- [S]earch [S]tring (grep)
					name = "[S]tring",
					c = { builtin.grep_string, "[C]urrent" },
					g = { builtin.live_grep, "[G]rep" },
					b = { builtin.current_buffer_fuzzy_find, "[B]uffer" },
				},
				g = {
					-- [S]earch [G]it
					name = "[G]it",
					c = { builtin.git_commits, "[C]ommits" },
					s = { builtin.git_status, "[S]tatus" },
					b = { builtin.git_branches, "[B]ranches" },
					t = { builtin.git_stash, "s[T]ash" },
				},
			},
		})

		-- Slightly advanced example of overriding default behavior and theme
		-- map("/", function()
		-- 	-- You can pass additional configuration to telescope to change theme, layout, etc.
		-- 	builtin.current_buffer_fuzzy_find(themes.get_dropdown({
		-- 		winblend = 10,
		-- 		previewer = false,
		-- 	}))
		-- end, "[/] Fuzzily search in current buffer")

		-- Disable folding in Telescope's result window.
		vim.api.nvim_create_autocmd("FileType", { pattern = "TelescopeResults", command = [[setlocal nofoldenable]] })
	end,
}
