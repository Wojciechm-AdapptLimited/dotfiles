return {
	options = {
		breakindent = true, -- enable break indent (wrap long lines)
		clipboard = "unnamedplus", -- keep the clipboard synced with the systemlist
		completeopt = "menu,menuone,noselect", -- decide how Insert mode completions work
		confirm = true, -- confirm if to save changes before exiting modified buffer
		cursorline = true, -- highlight the current line
		expandtab = true, -- use spaces instead of tabs
		foldmethod = "expr", -- set the fold method
		foldnestmax = 2, -- set the maximum fold nesting
		foldlevel = 99, -- set the minimum level the fold will be closed by default
		foldlevelstart = 0, -- set the fold level
		hidden = true, -- enable modified buffers in the background
		history = 500, -- use the "history" option to set the number of remembered commands from the Command mode
		hlsearch = true, -- set highlight on search
		ignorecase = true, -- use the case-insensitive searching
		inccommand = "split", -- preview substitutions
		list = true, -- set whether to use listchars
		listchars = { tab = "» ", trail = "·", nbsp = "␣" },
		mouse = "a", -- enable mouse mode
		number = true, -- set numbered lines
		relativenumber = false, -- set relative numbered lines
		scrolloff = 10, -- set the minimal number of screen lines to keep above and below the cursor
		shiftround = true, -- round indent
		shiftwidth = 2, -- set the number of spaces inserted for each indentation
		showmode = false, -- hide the mode, since it is already in the status line
		showtabline = 2, -- always show tabs: 0 never, 1 only if at least two tab pages, 2 always
		sidescrolloff = 5, -- set the minimal number of columns to scroll horizontally
		signcolumn = "yes", -- show the signcolumn, otherwise it would shift the text each time
		smartcase = true, -- don't ignore case with capitals
		smartindent = true, -- insert indents automatically
		splitbelow = true, -- force all horizontal splits to go below current window
		splitright = true, -- force all vertical splits to go to the right of current window
		swapfile = true, -- enable swap file creation
		tabstop = 2, -- set how many columns a tab counts for
		termguicolors = true, -- set term gui true colors (most terminals support this)
		timeoutlen = 300, -- set time to wait for a mapped sequence to complete (in milliseconds)
		ttimeoutlen = 0, -- set time in milliseconds to wait for a key code sequence to complete
		undofile = true, -- enable undo file creation
		undolevels = 1000, -- set the number of undo levels
		updatetime = 300, -- set time to place completion
		wildignorecase = true, -- ignore when completing file names and directories
		wildmode = "longest:full,full", -- decide how Command mode command-line completions work
		winminwidth = 5, -- set minimum window width
		wildignore = [[
		 .git,.hg,.svn 
		 *.aux,*.out,*.toc 
		 *.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class 
		 *.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
		 *.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
		 *.mp3,*.oga,*.ogg,*.wav,*.flac
		 *.eot,*.otf,*.ttf,*.woff 
		 *.doc,*.pdf,*.cbr,*.cbz
		 *.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
		 *.swp,.lock,.DS_Store,._* 
		 */tmp/*,*.so,*.swp,*.zip,**/node_modules/**,**/target/**,**.terraform/**"
		]],
	},

	theme = "catppuccin_mocha",

	dev_path = "$HOME/Projects",

	ignored_files = {
		"%.7z",
		"%.avi",
		"%.JPEG",
		"%.JPG",
		"%.V",
		"%.RAF",
		"%.burp",
		"%.bz2",
		"%.cache",
		"%.class",
		"%.dll",
		"%.docx",
		"%.dylib",
		"%.epub",
		"%.exe",
		"%.flac",
		"%.ico",
		"%.ipynb",
		"%.jar",
		"%.jpeg",
		"%.jpg",
		"%.lock",
		"%.mkv",
		"%.mov",
		"%.mp4",
		"%.otf",
		"%.pdb",
		"%.pdf",
		"%.png",
		"%.rar",
		"%.sqlite3",
		"%.svg",
		"%.tar",
		"%.tar.gz",
		"%.ttf",
		"%.webp",
		"%.zip",
		".git/",
		".gradle/",
		".idea/",
		".vale/",
		".vscode/",
		"__pycache__/*",
		"build/",
		"env/",
		"gradle/",
		"node_modules/",
		"smalljre_*/*",
		"target/",
		"vendor/*",
	},

	cmp_sources = {
		"copilot",
		"nvim_lsp",
		"buffer",
		"luasnip",
		"calc",
		"path",
		"rg",
		"emoji",
	},

	parsers = {
		angular = {},
		bash = { "sh", "zsh" },
		bibtex = {},
		c = {},
		c_sharp = {},
		cpp = {},
		css = {},
		csv = {},
		cmake = {},
		dockerfile = {},
		gitignore = {},
		go = {},
		html = {},
		java = {},
		javascript = {},
		jinja = {},
		jsdoc = {},
		json = {},
		latex = {},
		lua = {},
		markdown = {},
		prisma = {},
		python = {},
		r = {},
		regex = {},
		rust = {},
		scss = {},
		sql = {},
		templ = {},
		toml = {},
		typescript = {},
		vim = {},
		xml = {},
		yaml = {},
		zig = {},
	},

	ft = {
		ext = {
			jinja = { "jinja", "jinja2" },
		},
		pattern = {
			htmlangular = { "*.component.html" }, -- map htmlangular to component.html
		},
	},

	lsp_servers = {
		angularls = {},
		arduino_language_server = {},
		bashls = {
			filetypes = { "sh", "bash", "zsh" }, -- specify filetypes for bashls
		},
		buf_ls = {},
		clangd = {},
		cmake = {},
		css_variables = {},
		cssls = {},
		cssmodules_ls = {},
		docker_compose_language_service = {},
		dockerls = {},
		gh_actions_ls = {},
		gopls = {},
		html = {
			filetypes = { "html", "htmlangular", "jinja", "razor", "templ" },
		},
		htmx = {
			filetypes = {
				"aspnetcorerazor",
				"astro",
				"astro-markdown",
				"blade",
				"clojure",
				"django-html",
				"htmldjango",
				"edge",
				"eelixir",
				"elixir",
				"ejs",
				"erb",
				"eruby",
				"gohtml",
				"gohtmltmpl",
				"haml",
				"handlebars",
				"hbs",
				"html",
				"htmlangular",
				"html-eex",
				"heex",
				"jade",
				"jinja",
				"leaf",
				"liquid",
				"markdown",
				"mdx",
				"mustache",
				"njk",
				"nunjucks",
				"php",
				"razor",
				"slim",
				"twig",
				"javascript",
				"javascriptreact",
				"reason",
				"rescript",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
				"templ",
			},
		},
		hyprls = {},
		jdtls = {},
		jinja_lsp = {},
		jsonls = {},
		lemminx = {},
		ltex_plus = {
			filetypes = { "bib", "gitcommit", "markdown", "org", "text", "pandoc", "mail", "text" },
		},
		lua_ls = {
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace", -- replace the snippet with the function call
					},
					diagnostics = {
						globals = { "vim" }, -- recognize vim global variable
					},
					workspace = {
						checkThirdParty = false, -- disable third-party workspace checks
					},
				},
			},
		},
		marksman = {},
		omnisharp = {},
		pyright = {},
		r_language_server = {},
		ruff = {},
		rust_analyzer = {},
		sqlls = {},
		systemd_ls = {},
		templ = {},
		texlab = {},
		ts_ls = {},
		yamlls = {},
		zls = {},
	},

	lsp_additional_capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true, -- enable dynamic registration for file watching
			},
		},
	},

	tools = {
		formatters = {
			python = { "black" },
			javascript = { "prettierd" },
			html = { "prettierd" },
			htmlangular = { "prettierd" },
			css = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			markdown = { "prettierd" },
			lua = { "stylua" },
			bash = { "shfmt" },
			buf = { "buf" },
			bibtex = { "bibtex-tidy" },
			cs = { "csharpier" },
			go = { "gofumpt", "goimports" },
			latex = { "latexindent" },
			yaml = { "yamlfmt" },
			jinja = { "djlint" },
			xml = { "xmlformatter" },
			zig = { "zigfmt" },
		},

		linters = {
			gitcommit = { "commitlint" },
		},
	},
}
