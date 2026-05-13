-- Core Neovim options

local opt = vim.opt

-- Encoding
opt.encoding = "UTF-8"
opt.fileencoding = "utf-8"

-- Backspace behavior
opt.backspace = { "indent", "eol", "start" }

-- Persistent undo
opt.undodir = vim.fn.expand("~/.nvimundo")
opt.undofile = true

-- UI & appearance
opt.background = "dark"
opt.colorcolumn = "80"
opt.scrolloff = 10
opt.textwidth = 0
opt.cursorline = true
opt.relativenumber = true
opt.number = true
opt.signcolumn = "yes" -- Always show signcolumn to prevent shifting
opt.termguicolors = true -- Enable 24-bit RGB colors

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10 -- Max items in popup menu

-- Messages and command line
opt.cmdheight = 1
opt.updatetime = 300 -- Faster completion (default 4000ms)
opt.timeoutlen = 300 -- Faster key sequence completion

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.gdefault = true
opt.hlsearch = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Clipboard (use system clipboard)
opt.clipboard = "unnamedplus"

-- Mouse support
opt.mouse = "a"

-- Indentation
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2

-- Grep program
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --no-heading --vimgrep"
  opt.grepformat = "%f:%l:%c:%m"
elseif vim.fn.executable("ag") == 1 then
  opt.grepprg = "ag --nogroup --nocolor"
end
