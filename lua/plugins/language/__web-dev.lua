local u = require("utils")
return {
  {
    "xlboy/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, {
        "html",
        "css",
        "javascript",
        "json",
        "tsx",
        "typescript",
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, {
        "html",
        "cssls",
        -- "tsserver",
        "jsonls",
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, { "prettier" })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    enabled = true,
    ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup({
        settings = {
          separate_diagnostic_server = false,
          tsserver_file_preferences = {
            includeCompletionsForModuleExports = true,
            quotePreference = "auto",
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      cssls = {
        settings = {
          css = {
            lint = {
              unknownAtRules = "ignore",
            },
          },
          less = {
            lint = {
              unknownAtRules = "ignore",
            },
          },
          scss = {
            validate = false,
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      },
    },
  },
}
