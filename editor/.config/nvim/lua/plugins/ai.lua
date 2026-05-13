-- AI Tools: GitHub Copilot and Avante

return {
  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    lazy = true, -- Don't load automatically
    cmd = "Copilot", -- Load only when called
    opts = {
      suggestion = {
        enabled = false, -- Disabled AI inline suggestions
        auto_trigger = false,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = false,
        gitrebase = false,
        ["."] = false,
      },
    },
  },

  -- Avante.nvim - AI-powered coding assistant
  {
    "yetone/avante.nvim",
    lazy = true, -- Load only when called
    cmd = { "AvanteAsk", "AvanteEdit", "AvanteToggle" }, -- Load only on these commands
    keys = {
      { "<leader><leader>aa", "<cmd>AvanteAsk<cr>", desc = "Avante Ask" },
      { "<leader><leader>ae", "<cmd>AvanteEdit<cr>", desc = "Avante Edit" },
      { "<leader><leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante Toggle" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua",
      "MeanderingProgrammer/render-markdown.nvim",
      "stevearc/dressing.nvim",
      "folke/snacks.nvim",
    },
    opts = {
      provider = "copilot",
      providers = {
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "claude-sonnet-4",
          allow_insecure = false,
          timeout = 10 * 60 * 1000,
          temperature = 0,
          max_completion_tokens = 1000000,
          reasoning_effort = "high",
        },
      },
      behaviour = {
        auto_approve_tool_permissions = false,
        auto_suggestions = false, -- Disable auto suggestions
        auto_set_highlight_group = false,
        auto_set_keymaps = false,
      },
      mappings = {
        ask = "<leader><leader>aa",
        edit = "<leader><leader>ae",
        refresh = "<leader><leader>ar",
        toggle = {
          default = "<leader><leader>at",
          debug = "<leader><leader>ad",
          hint = "<leader><leader>ah",
        },
      },
      hints = { enabled = false }, -- Disable hints
      windows = {
        position = "right",
        wrap = true,
        width = 30,
      },
    },
    build = "make",
    config = function(_, opts)
      require("avante").setup(opts)
    end,
  },

  -- Render markdown for better display
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      file_types = { "markdown", "Avante" },
    },
  },
}
