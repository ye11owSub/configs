-- Autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Format options
augroup("FormatOptions", { clear = true })
autocmd("FileType", {
  group = "FormatOptions",
  pattern = { "typescript", "json" },
  callback = function()
    vim.opt_local.formatexpr = "v:lua.vim.lsp.formatexpr()"
  end,
})

-- Auto resize splits on window resize
augroup("AutoResize", { clear = true })
autocmd("VimResized", {
  group = "AutoResize",
  pattern = "*",
  command = "wincmd =",
})

-- Auto change to project root directory
augroup("AutoRoot", { clear = true })
autocmd("BufEnter", {
  group = "AutoRoot",
  callback = function(event)
    local root = vim.fs.root(event.buf, { ".git", "Makefile", "package.json", "Cargo.toml" })
    if root then
      vim.fn.chdir(root)
    end
  end,
})

-- Close some filetypes with <q>
augroup("QuickClose", { clear = true })
autocmd("FileType", {
  group = "QuickClose",
  pattern = { "qf", "help", "man", "lspinfo", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
