local ft = vim.filetype
local conf = vim.g.config

local extensions = {}
local patterns = {}

for filetype, exts in pairs(conf.ft.ext) do
	for _, ext in ipairs(exts) do
		extensions[ext] = filetype
	end
end

for filetype, pats in pairs(conf.ft.pattern) do
	for _, pat in ipairs(pats) do
		patterns[pat] = filetype
	end
end

ft.add({
	extension = extensions,
	pattern = patterns,
})
