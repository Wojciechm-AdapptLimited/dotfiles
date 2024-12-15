return {
	"glench/vim-jinja2-syntax",
	config = function()
		vim.filetype.add({
			extension = {
				jinja2 = "jinja",
			},
		})

		local lspconfig = require("lspconfig")
		-- ...
		lspconfig.htmx.setup({
			filetypes = { "jinja", "html" },
		})
		lspconfig.html.setup({
			filetypes = { "jinja", "html" },
		})
	end,
}
