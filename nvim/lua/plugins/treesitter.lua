local conf = vim.g.config

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	branch = "master",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"RRethy/nvim-treesitter-endwise",
		"mfussenegger/nvim-ts-hint-textobject",
		"windwp/nvim-ts-autotag",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			modules = {},
			ensure_installed = conf.parsers,
			ignore_install = {},
			auto_install = true,
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
			endwise = { enable = true },
			textobjects = { select = { enable = true } },
			incremental_selection = { enable = true },
		})

		require("nvim-ts-autotag").setup()

		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.treesitter.language.register("bash", "zsh")

		vim.api.nvim_create_autocmd("BufWritePre", {
			desc = "Reload foldexpr on save",
			group = vim.api.nvim_create_augroup("TS", { clear = true }),
			command = "set foldmethod=expr",
		})
	end,
}
