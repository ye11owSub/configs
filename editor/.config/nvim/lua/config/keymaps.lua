-- Key mappings

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Quick save
map("n", "<leader>w", ":w<CR>", opts)

-- Move by visual line
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)

-- Clear search highlighting and dismiss notifications
map("n", "<S-h>", function()
  vim.cmd("nohlsearch")
  require("notify").dismiss({ silent = true, pending = true })
end, opts)
map("v", "<S-h>", function()
  vim.cmd("nohlsearch")
  require("notify").dismiss({ silent = true, pending = true })
end, opts)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize windows with arrows
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", opts)
-- <S-h> now used for clearing search highlight (see line 14)

-- Better indent
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move text up and down
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered on search and join
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "J", "mzJ`z", opts)
