-- LSP Configuration: nvim-lspconfig + mason + mason-lspconfig

return {
  -- Mason: auto-install LSP servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },

  -- Bridge mason ↔ lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "ts_ls",
        "basedpyright",
        "rust_analyzer",
        "gopls",
        "jdtls",
        "jsonls",
        "taplo",
        "lua_ls",
      },
      automatic_installation = true,
    },
  },

  -- LSP configs
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_lsp.default_capabilities()

      -- Diagnostics signs
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Diagnostics config
      vim.diagnostic.config({
        virtual_text = {
          severity = { min = vim.diagnostic.severity.ERROR },
        },
        signs = true,
        underline = {
          severity = { min = vim.diagnostic.severity.ERROR },
        },
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })

      -- Keymaps & highlight on LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then return end

          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          -- Navigation
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          map("n", "gr", vim.lsp.buf.references, "Go to references")
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

          -- Diagnostics
          map("n", "[g", vim.diagnostic.goto_prev, "Previous diagnostic")
          map("n", "]g", vim.diagnostic.goto_next, "Next diagnostic")
          map("n", "<space>a", vim.diagnostic.setloclist, "Diagnostics list")

          -- Actions
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map({ "n", "x" }, "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format")
          map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>ac", vim.lsp.buf.code_action, "Code action (cursor)")
          map("n", "<leader>qf", function()
            vim.lsp.buf.code_action({
              filter = function(a) return a.isPreferred end,
              apply = true,
            })
          end, "Quick fix")

          -- Code lens
          map("n", "<leader>cl", vim.lsp.codelens.run, "Run code lens")

          -- Symbols via Telescope
          map("n", "<space>o", function()
            require("telescope.builtin").lsp_document_symbols()
          end, "Document symbols")
          map("n", "<space>s", function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols()
          end, "Workspace symbols")

          -- Inlay hints (parameter names, type hints)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end

          -- Highlight symbol under cursor
          if client.server_capabilities.documentHighlightProvider then
            local hl_group = vim.api.nvim_create_augroup("LspHighlight_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd("CursorHold", {
              group = hl_group,
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              group = hl_group,
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end

          -- Format on save
          local format_filetypes = {
            javascript = true, typescript = true, json = true,
            python = true, rust = true, go = true, toml = true,
          }
          if format_filetypes[vim.bo[bufnr].filetype] and client.server_capabilities.documentFormattingProvider then
            local fmt_group = vim.api.nvim_create_augroup("LspFormat_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = fmt_group,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 3000 })
              end,
            })
          end
        end,
      })

      -- Server configs via vim.lsp.config (Neovim 0.11+ API)
      local servers = {
        ts_ls = {},
        -- basedpyright is used instead of pyright because pyright does not
        -- implement the textDocument/inlayHint LSP capability (no parameter
        -- name hints). basedpyright is a drop-in replacement that adds this.
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                autoImportCompletions = true,
                inlayHints = {
                  callArgumentNames = "all",
                  functionReturnTypes = true,
                  variableTypes = true,
                },
              },
            },
          },
        },
        gopls = {},
        jsonls = {},
        taplo = {},
        jdtls = {
          settings = {
            java = {
              configuration = {
                runtimes = {
                  {
                    name = "JavaSE-17",
                    path = "/opt/homebrew/opt/openjdk",
                    default = true,
                  },
                },
              },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
              checkOnSave = true,
              diagnostics = { enable = true },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
      }

      local server_names = {}
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config(server, config)
        table.insert(server_names, server)
      end
      vim.lsp.enable(server_names)

      -- Commands
      vim.api.nvim_create_user_command("Format", function()
        vim.lsp.buf.format({ async = true })
      end, {})
      vim.api.nvim_create_user_command("OR", function()
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply = true,
        })
      end, {})
    end,
  },
}
