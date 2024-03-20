-- Theme setup

local themes_path = "plugins.themes"

local themes = {
	tokyonight_night = {
		"folke/tokyonight.nvim",
		branch = "main",
		config = function()
			require(themes_path .. ".tokyonight")
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	tokyonight_day = {
		"folke/tokyonight.nvim",
		branch = "main",
		config = function()
			require(themes_path .. ".tokyonight")
			vim.cmd.colorscheme("tokyonight-day")
		end,
	},
	catppuccin_latte = {
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require(themes_path .. ".catppuccin")
			vim.cmd.colorscheme("catppuccin-latte")
		end,
	},
	catppuccin_frappe = {
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require(themes_path .. ".catppuccin")
			vim.cmd.colorscheme("catppuccin-frappe")
		end,
	},
	catppuccin_mocchiato = {
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require(themes_path .. ".catppuccin")
			vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
	catppuccin_mocha = {
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require(themes_path .. ".catppuccin")
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
}

local theme = themes[vim.g.config.theme]
theme.lazy = false
theme.priority = 1000

return theme
