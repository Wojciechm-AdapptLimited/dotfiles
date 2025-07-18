-- Fuzzy Finder (files, lsp, etc)

local conf = vim.g.config

return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
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
		"nvim-tree/nvim-web-devicons",

		-- Telescope extensions
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
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
				find_files = { hidden = true },
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
		pcall(telescope.load_extension, "file_browser")

		wk.add({
			{ "<leader><leader>", builtin.buffers, desc = "Existing Buffers" },
			{ "<leader>f", telescope.extensions.file_browser.file_browser, desc = "[F]ile Browser" },
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

			-- [S]earch [C]ode
			{ "<leader>sc", group = "[C]ode" },
			{ "<leader>scd", builtin.lsp_document_symbols, desc = "[D]ocument" },
			{ "<leader>scw", builtin.lsp_dynamic_workspace_symbols, desc = "[W]orkspace" },
		})

		-- Disable folding in Telescope's result window.
		vim.api.nvim_create_autocmd("FileType", { pattern = "TelescopeResults", command = [[setlocal nofoldenable]] })

		-- Enable wrapping in Telescope's preview window.
		vim.api.nvim_create_autocmd("User", {
			pattern = "TelescopePreviewerLoaded",
			callback = function()
				vim.wo.wrap = true
			end,
		})
	end,
}
