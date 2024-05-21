local map = vim.keymap.set

-- clear search highlight by pressing <Esc> in Normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- diagnostic keymaps
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- window keymaps
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- buffer keymaps
-- map("n", "<tab>", "<cmd>bnext<cr>", { desc = "Move to the next buffer" })
-- map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Move to the previous buffer" })
-- map("n", "<leader>bD", "<cmd>%bd|e#|bd#<cr>", { desc = "Close all but the current buffer" })
-- map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close the current buffer" })
-- map("n", "<leader>bl", "<cmd>e#<cr>", { desc = "Move to the last visited buffer" })
