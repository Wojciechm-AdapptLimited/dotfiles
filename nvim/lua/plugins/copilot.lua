return {
	"zbirenbaum/copilot.lua",
	build = ":Copilot auth",
	config = function()
		require("copilot").setup({
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				markdown = true,
			},
		})

		vim.keymap.set("n", "<leader>ag", "<cmd>Copilot attach<CR>", { desc = "[G]ithub Copilot" })
	end,
}
