-- Theme setup

local themes_path = "plugins.themes."
local theme = require(themes_path .. vim.g.config.theme)

theme.lazy = false
theme.priority = 1000

return theme
