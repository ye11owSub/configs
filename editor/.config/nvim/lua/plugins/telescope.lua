-- Telescope fuzzy finder

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = {
      { ",f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { ",g", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { ",b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { ",h", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { ",r", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { ",s", "<cmd>Telescope grep_string<cr>", desc = "Grep String" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      
      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
            },
          },
          
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "dist/",
            "build/",
            "target/",
            "*.min.js",
          },
        },
        
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
        
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      
      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("noice")
    end,
  },

}
