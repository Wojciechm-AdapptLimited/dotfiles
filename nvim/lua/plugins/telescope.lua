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

		-- See `:help telescope.builtin`
		local map = function(keys, func, desc)
			vim.keymap.set("n", "<leader>" .. keys, func, { desc = desc })
		end

		-- Search Core (files, strings, buffers, commands)
		map("<leader>", builtin.buffers, "[ ] Find existing buffers")
		map("sf", builtin.find_files, "[S]earch [F]iles")
		map("s.", builtin.oldfiles, "[S]earch Recent Files ('.' for repeat)")
		map("sw", builtin.grep_string, "[S]earch current [W]ord")
		map("ss", builtin.live_grep, "[S]earch [S]tring")
		map("st", builtin.treesitter, "[S]earch [T]reesitter (function names, variables)")
		map("s:", builtin.commands, "[S]earch [:]commands")
		map("sr", builtin.registers, "[S]earch [R]egisters")

		-- Search Meta (manuals, diagnostics, builtin,
		map("sh", builtin.help_tags, "[S]earch [H]elp")
		map("sk", builtin.keymaps, "[S]earch [K]eymaps")
		map("sb", builtin.builtin, "[S]earch [B]uiltin")
		map("sd", builtin.diagnostics, "[S]earch [D]iagnostics")

		-- Search Git
		map("sgc", builtin.git_commits, "[S]earch [G]it [C]ommits")
		map("sgs", builtin.git_status, "[S]earch [G]it [S]tatus")
		map("sgb", builtin.git_branches, "[S]earch [G]it [B]ranches")
		map("sgt", builtin.git_stash, "[S]earch [G]it s[T]ash")

		-- Slightly advanced example of overriding default behavior and theme
		map("/", function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			builtin.current_buffer_fuzzy_find(themes.get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, "[/] Fuzzily search in current buffer")

		-- Also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		map("s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, "[S]earch by grep [/] in Open Files")

		-- Shortcut for searching your neovim configuration files
		map("sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, "[S]earch [N]eovim files")
	end,
}
