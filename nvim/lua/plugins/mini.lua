-- Collection of various small independent plugins/modules

return {
	{
		"echasnovski/mini.nvim",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]parenthen
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Align text interactively (Start - 'ga')
			--
			-- Examples:
			--  - gaip - [G]toggle [A]lign [I]gnore [P]air
			--  - jc   - [J]ustify [C]enter
			--  - s=   - [S]plit [=]on equals
			require("mini.align").setup()

			-- Comment lines
			--
			-- - gc   - [G]toggle [C]omment
			-- - gcc  - [G]toggle [C]omment [C]whole line
			require("mini.comment").setup()

			-- Automatic highlighting of word under cursor
			require("mini.cursorword").setup()

			-- Move any selection in any direction (Defaults are Alt (<M>eta) + hjkl)
			require("mini.move").setup()

			-- Simple and easy statusline.
			require("mini.statusline").setup()

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- Examples
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
		end,
	},
}
