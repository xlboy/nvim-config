local config = require("terminal.config.config")
local u = require("terminal.utils")

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
    "neovim/nvim-lspconfig",
    opts = {
      clangd = {
        cmd = {
          "clangd",
          "--offset-encoding=utf-16",
        },
      },
    },
  },
}
