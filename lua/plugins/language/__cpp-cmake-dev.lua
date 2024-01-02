local constants = require("config.constants")
local u = require("utils")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if constants.IS_WIN then
        opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, { "c", "cpp", "cmake" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      if constants.IS_WIN then
        u.basic.append_arrays(opts.ensure_installed, {
          "clangd",
          "neocmake",
        })
      end
    end,
  },
}
