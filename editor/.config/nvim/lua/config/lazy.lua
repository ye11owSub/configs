-- Lazy.nvim plugin configuration

require("lazy").setup({
  -- Import all plugins from lua/plugins/*.lua
  spec = {
    { import = "plugins" },
  },
  
  -- Plugin manager UI settings
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
  
  -- Performance settings
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  
  -- Check for updates
  checker = {
    enabled = true,
    notify = false,
  },
  
  change_detection = {
    notify = false,
  },
})
