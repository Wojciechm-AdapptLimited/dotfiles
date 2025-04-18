-- LaTex plugin for Neovim

local g = vim.g

return {
	"lervag/vimtex",
	ft = "tex",
	config = function()
		g.tex_flavor = "latex"

		g.vimtex_view_method = "general"
		g.vimtex_view_skim_sync = 1
		g.vimtex_view_skim_activate = 1

		g.vimtex_compiler_method = "tectonic"
		g.vimtex_compiler_tectonic = {
			options = {
				"--keep-logs",
				"--synctex",
				'-Z shell-escape-cwd="."',
			},
		}
		g.vimtex_mappings_enabled = false

		-- Do not auto open quickfix on compile errors
		g.vimtex_quickfix_mode = 0

		-- vimtex toc options
		g.vimtex_toc_config = {
			split_pos = "rightbelow",
			split_width = 20,
			show_help = 0,
		}

		g.vimtex_grammar_textidote = {
			jar = "/Users/wojciech/.local/bin/textidote.jar",
			args = { "--check", "en" },
		}

		-- Latex warnings to ignore
		g.vimtex_quickfix_ignore_filters = {
			"Command terminated with space",
			"LaTeX Font Warning: Font shape",
			"Package caption Warning: The option",
			[[Underfull \\hbox (badness [0-9]*) in]],
			"Package enumitem Warning: Negative labelwidth",
			[[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in]],
			[[Package caption Warning: Unused \\captionsetup]],
			"Package typearea Warning: Bad type area settings!",
			[[Package fancyhdr Warning: \\headheight is too small]],
			[[Underfull \\hbox (badness [0-9]*) in paragraph at lines]],
			"Package hyperref Warning: Token not allowed in a PDF string",
			[[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in paragraph at lines]],
		}

		vim.api.nvim_create_autocmd("BufWritePre", {
			desc = "Compile tex file on save",
			group = vim.api.nvim_create_augroup("Tex", { clear = true }),
			command = "VimtexCompile",
		})
	end,
}
