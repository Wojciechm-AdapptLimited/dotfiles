-- AI

return {
	"olimorris/codecompanion.nvim",
	branch = "main",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		local cc = require("codecompanion")
		cc.setup({
			adapters = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								default = "qwen3:32b",
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "ollama",
				},
				inline = {
					adapter = "copilot",
				},
			},
			opts = {
				log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
			},
		})

		local wk = require("which-key")

		wk.add({
			-- [A]I
			{ "<leader>a", group = "[A]I" },
			{ "<leader>aa", cc.actions, desc = "[A]ctions" },
			{ "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "[C]hat" },

			{ "ca", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "[A]dd to chat" },
		})
	end,
}
