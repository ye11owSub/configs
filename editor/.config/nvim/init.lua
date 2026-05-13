-- Neovim 0.12+ Configuration
-- Migrated from init.vim with modern best practices

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before loading plugins (backslash - default Vim behavior)
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- Load core settings
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Load plugins
require("config.lazy")
