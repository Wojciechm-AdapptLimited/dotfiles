-- Debugging

local conf = vim.g.config

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",

		-- Required dependency for nvim-dap-ui
		"nvim-neotest/nvim-nio",

		-- Installs the debug adapters for you
		"mason-org/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	config = function()
		-- ensure debuggers are installed
		local installer = require("config.mason")
		installer.ensure_installed(conf.debuggers)

		local dap = require("dap")
		local dapui = require("dapui")

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		-- Change breakpoint icons
		vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
		vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
		local breakpoint_icons = vim.g.have_nerd_font
				and {
					Breakpoint = "",
					BreakpointCondition = "",
					BreakpointRejected = "",
					LogPoint = "",
					Stopped = "",
				}
			or {
				Breakpoint = "●",
				BreakpointCondition = "⊜",
				BreakpointRejected = "⊘",
				LogPoint = "◆",
				Stopped = "⭔",
			}
		for type, icon in pairs(breakpoint_icons) do
			local tp = "Dap" .. type
			local hl = (type == "Stopped") and "DapStop" or "DapBreak"
			vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
		end

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- Configure keymaps
		local wk = require("which-key")
		wk.add({
			{ "<leader>d", group = "[D]ebug" },

			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "[C]ontinue/Start",
			},

			{ "<leader>ds", group = "[S]tep" },
			{
				"<leader>dsi",
				function()
					require("dap").step_into()
				end,
				desc = "[I]nto",
			},
			{
				"<leader>dso",
				function()
					require("dap").step_over()
				end,
				desc = "[O]ver",
			},
			{
				"<leader>dsu",
				function()
					require("dap").step_out()
				end,
				desc = "O[u]t",
			},

			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle [B]reakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Set [B]reakpoint",
			},
			-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
			{
				"<leader>dr",
				function()
					require("dapui").toggle()
				end,
				desc = "See last session [r]esult.",
			},
		})
	end,
}
