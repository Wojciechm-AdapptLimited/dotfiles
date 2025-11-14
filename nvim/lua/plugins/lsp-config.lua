-- LSP Configuration & Plugins

local conf = vim.g.config
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	branch = "master",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for neovim
		{ "williamboman/mason.nvim", branch = "main" },
		{ "williamboman/mason-lspconfig.nvim", branch = "main" },
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		vim.diagnostic.config({
			virtual_text = {
				source = "always",
			},
			float = {
				border = "rounded",
				source = "always",
			},
			update_in_insert = true,
			severity_sort = true,
		})

		autocmd("LspAttach", {
			group = augroup("LspAttach", { clear = true }),
			callback = function(event)
				local wk = require("which-key")
				local builtin = require("telescope.builtin")

				wk.add({
					-- [G]oto (To jump back, press <C-T>)
					{ "<leader>g", group = "[G]oto" },
					{ "<leader>gd", builtin.lsp_definitions, desc = "[D]efinition" },
					{ "<leader>gD", vim.lsp.buf.declaration, desc = "[D]eclaration" },
					{ "<leader>gr", builtin.lsp_references, desc = "[R]eferences" },
					{ "<leader>gi", builtin.lsp_implementations, desc = "[I]mplementation" },
					{ "<leader>gt", builtin.lsp_type_definitions, desc = "[T]ype" },
					{ "<leader>gh", vim.lsp.buf.typehierarchy, desc = "[H]ierarchy" },

					-- [C]ode actions
					{ "<leader>c", group = "[C]ode" },
					{ "<leader>cr", vim.lsp.buf.rename, desc = "[R]ename" },
					{ "<leader>ca", vim.lsp.buf.code_action, desc = "[A]ction" },
				})

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})

					autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})

		require("lspconfig.ui.windows").default_options = {
			border = "rounded",
		}

		require("mason").setup({
			ui = {
				border = "rounded",
			},
		})

		-- install LSPs
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(conf.lsp_servers),
		})

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP Specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, conf.lsp_additional_capabilities)
		capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

		for server_name, server in pairs(conf.lsp_servers) do
			-- This handles overriding only values explicitly passed
			-- by the server configuration above. Useful when disabling
			-- certain features of an LSP (for example, turning off formatting for tsserver)
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			vim.lsp.config(server_name, {
				capabilities = server.capabilities,
				filetypes = server.filetypes,
				settings = server.settings,
			})
		end
	end,
}
