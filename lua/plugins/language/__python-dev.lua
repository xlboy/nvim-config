local config = require("config.config")
local u = require("utils")

return {
  {
    "xlboy/nvim-treesitter",
    opts = function(_, opts)
      if config.IS_WIN then opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, { "python" }) end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      if config.IS_WIN then u.basic.append_arrays(opts.ensure_installed, {
        "pyright",
      }) end
    end,
  },
}
