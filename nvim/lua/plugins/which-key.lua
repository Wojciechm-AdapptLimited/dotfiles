-- Useful plugin to show you pending keybinds.

return {
	"folke/which-key.nvim",
	event = "VeryLazy", -- Sets the loading event to 'VeryLazy'
	config = function() -- This is the function that runs, AFTER loading
		require("which-key").setup()
	end,
}
