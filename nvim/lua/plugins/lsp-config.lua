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

				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				wk.add({
					{ "<leader>g", group = "[G]oto" },

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-T>.
					{ "<leader>gd", builtin.lsp_definitions, desc = "[D]efinition" },

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header
					{ "<leader>gD", vim.lsp.buf.declaration, desc = "[D]eclaration" },

					-- Find references for the word under your cursor.
					{ "<leader>gr", builtin.lsp_references, desc = "[R]eferences" },

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					{ "<leader>gi", builtin.lsp_implementations, desc = "[I]mplementation" },

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					{ "<leader>gt", builtin.lsp_type_definitions, desc = "[T]ype" },

					-- Find all supertypes of the word under your cursor.
					{ "<leader>gh", vim.lsp.buf.typehierarchy, desc = "[H]ierarchy" },
				})

				wk.add({
					{ "<leader>c", group = "[C]ode" },

					-- Rename the variable under your cursor
					--  Most Language Servers support renaming across files, etc.
					{ "<leader>cr", vim.lsp.buf.rename, desc = "[R]ename" },

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					{ "<leader>ca", vim.lsp.buf.code_action, desc = "[A]ction" },
				})

				wk.add({
					{ "<leader>sc", group = "[C]ode" },
					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					{ "<leader>scd", builtin.lsp_document_symbols, desc = "[D]ocument" },

					-- Fuzzy find all the symbols in your current workspace
					--  Similar to document symbols, except searches over your whole project.
					{ "<leader>scw", builtin.lsp_dynamic_workspace_symbols, desc = "[W]orkspace" },

					-- Fuzzy find all the symbols in your current workspace using treesitter
					{ "<leader>sct", builtin.treesitter, desc = "[T]reesitter" },
				})

				-- Opens a popup that displays documentation about the word under your cursor
				--  See `:help K` for why this keymap
				map("K", vim.lsp.buf.hover, "Hover Documentation")

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

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP Specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		require("mason").setup()

		-- ensure tools (except LSPs) are installed
		local mr = require("mason-registry")

		local function install(tool)
			if not mr.has_package(tool) then
				return
			end
			local p = mr.get_package(tool)
			if not p:is_installed() then
				p:install()
			end
		end

		local function ensure_installed(tools)
			for _, tool in pairs(tools) do
				if type(tool) == "table" then
					for _, subtool in ipairs(tool) do
						install(subtool)
					end
				else
					install(tool)
				end
			end
		end

		ensure_installed(conf.tools.formatters)
		ensure_installed(conf.tools.linters)

		-- install LSPs
		require("mason-lspconfig").setup({
			ensure_installed = conf.lsp_servers,
			handlers = {
				function(server_name)
					local server = conf.lsp_servers[server_name] or {}

					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
