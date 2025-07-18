return {
	"ray-x/go.nvim",
	branch = "master",
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("go").setup()
	end,
	ft = { "go", "gomod", "templ" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
