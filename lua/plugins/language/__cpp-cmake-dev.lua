local config = require("config.config")
local u = require("utils")

return {
  {
    "xlboy/nvim-treesitter",
    opts = function(_, opts)
      if config.IS_WIN then
        opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, { "c", "cpp", "cmake" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      if config.IS_WIN then
        u.basic.append_arrays(opts.ensure_installed, {
          "clangd",
          "neocmake",
        })
      end
    end,
  },
  {
    "AstroNvim/astrolsp",
    ---@diagnostic disable: missing-fields
    ---@type AstroLSPOpts
    opts = {
      config = {
        clangd = {
          -- settings = {
          --   cmd = {
          --     "clangd",
          --     "--offset-encoding=utf-8",
          --   },
          -- },
          capabilities = {
            offsetEncoding = "utf-8",
          },
        },
      },
    },
  },
}
