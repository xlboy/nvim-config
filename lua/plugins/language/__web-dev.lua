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
        "tailwindcss",
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
    ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    opts = function()
      return require("astrolsp").lsp_opts("typescript-tools")
    end,
  },
  {
    "AstroNvim/astrolsp",
    opts = {
      config = {
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
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      handlers = {
        tsserver = false, -- disable tsserver setup, this plugin does it
      },
      config = {
        ["typescript-tools"] = { -- enable inlay hints by default for `typescript-tools`
          settings = {
            separate_diagnostic_server = true,
            -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
            -- memory limit in megabytes or "auto"(basically no limit)
            tsserver_max_memory = "auto",
            code_lens = "all",
            tsserver_file_preferences = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              -- includeInlayFunctionParameterTypeHints = false,
              -- includeInlayVariableTypeHints = false,
              -- includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              -- includeInlayPropertyDeclarationTypeHints = true,
              -- includeInlayFunctionLikeReturnTypeHints = true,
              -- includeInlayEnumMemberValueHints = true,
              -- includeCompletionsForModuleExports = true,
              quotePreference = "auto",
            },
            tsserver_plugins = {},
            expose_as_code_action = "all",
          },
        },
      },
    },
  },
}
