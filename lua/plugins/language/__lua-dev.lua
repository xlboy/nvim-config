return {
  -- { "folke/neodev.nvim", opts = {}, ft = { "lua" } },
  {
    "rafcamlet/nvim-luapad",
    event = "VeryLazy",
    config = function()
      require("luapad").setup({
        eval_on_change = false,
        wipe = false,
      })
    end,
  },
}
