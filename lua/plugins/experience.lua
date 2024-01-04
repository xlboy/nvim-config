local u = require("utils")

return {
  {
    "Pocco81/true-zen.nvim",
    event = "VeryLazy",
    keys = { { "<leader>tzn", ":TZNarrow<CR>", mode = { "v", "n" } } },
    config = function()
      require("true-zen").setup({
        modes = {
          narrow = { folds_style = "invisible", run_ataraxis = false },
          ataraxis = { padding = { left = 13, right = 13 } },
        },
      })
    end,
  },
  {
    "AckslD/nvim-FeMaco.lua",
    ft = { "markdown" },
    config = function()
      require("femaco").setup()
    end,
  },
  { "tiagovla/scope.nvim", config = true },
}
