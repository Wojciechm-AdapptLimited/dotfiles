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

		wk.add({
			{ "<leader><leader>", builtin.buffers, desc = "Existing Buffers" },
			{ "<leader>s", group = "[S]earch" },

			-- [S]earch Core
			{ "<leader>sf", builtin.find_files, desc = "[F]iles" },
			{ "<leader>s:", builtin.commands, desc = "[:] (commands)" },
			{ "<leader>sr", builtin.registers, desc = "[R]egisters" },
			{ "<leader>sh", builtin.help_tags, desc = "[H]elp" },
			{ "<leader>sk", builtin.keymaps, desc = "[K]eymaps" },
			{ "<leader>sb", builtin.builtin, desc = "[B]uiltin" },
			{ "<leader>sd", builtin.diagnostics, desc = "[D]iagnostics" },
			{
				"<leader>sn",
				function()
					builtin.find_files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "[N]eovim (config)",
			},

			-- [S]earch [S]tring (grep)
			{ "<leader>ss", group = "[S]tring" },
			{ "<leader>ssc", builtin.grep_string, desc = "[C]urrent" },
			{ "<leader>ssg", builtin.live_grep, desc = "[G]rep" },
			{ "<leader>ssb", builtin.current_buffer_fuzzy_find, desc = "[B]uffer" },

			-- [S]earch [G]it
			{ "<leader>sg", group = "[G]it" },
			{ "<leader>sgc", builtin.git_commits, desc = "[C]ommits" },
			{ "<leader>sgs", builtin.git_status, desc = "[S]tatus" },
			{ "<leader>sgb", builtin.git_branches, desc = "[B]ranches" },
			{ "<leader>sgt", builtin.git_stash, desc = "s[T]ash" },
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
