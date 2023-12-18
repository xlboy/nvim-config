local u = require("utils")

return {
  {
    "folke/neodev.nvim",
    ft = { "lua" },
    event = "VeryLazy",
    config = function()
      u.lazy.on_load("mason-lspconfig.nvim", function()
        require("neodev").setup()
        require("lspconfig").lua_ls.setup({
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
            },
          },
        })
      end)
    end,
  },
  {
    "rafcamlet/nvim-luapad",
    event = "VeryLazy",
    config = function()
      require("luapad").setup({ eval_on_change = false, wipe = false })
    end,
  },
}
