-- Treesitter configuration (modern API for Neovim 0.12+)

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false, -- Treesitter doesn't support lazy loading
    config = function()
      -- Setup treesitter
      require("nvim-treesitter").setup({})
      
      -- Install parsers (including python)
      require("nvim-treesitter").install({
        "c", "cpp", "cuda", "vim", "vimdoc", "query",
        "markdown", "markdown_inline", "python", "rust",
        "commonlisp", "cmake", "yaml", "toml", "sql",
        "java", "bash", "lua", "json", "javascript", "typescript",
      })
      
      -- Enable treesitter highlighting for all filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(event)
          local buf = event.buf
          local ft = vim.bo[buf].filetype
          local lang = vim.treesitter.language.get_lang(ft) or ft
          if pcall(vim.treesitter.language.inspect, lang) then
            vim.treesitter.start(buf, lang)
          end
        end,
      })
    end,
  },
}
