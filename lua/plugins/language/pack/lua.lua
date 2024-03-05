local u = require("utils")

return {
  {
    "xlboy/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, { "lua", "luap" })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, { "stylua" })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, { "lua_ls" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      lua_ls = {
        settings = {
          Lua = {
            hint = { enable = true, arrayIndex = "Disable" },
            -- 给 neodev.nvim 配置用的
            completion = { callSnippet = "Replace" },
          },
        },
      },
    },
  },
  {
    "folke/neodev.nvim",
    ft = { "lua" },
    config = function()
      u.lazy.on_load("mason-lspconfig.nvim", function()
        require("neodev").setup()
      end)
    end,
  },
  {
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad", "LuaRun" },
    config = function()
      require("luapad").setup({ eval_on_change = false, wipe = false })
    end,
  },
}