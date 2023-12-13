return {
  {
    "Pocco81/true-zen.nvim",
    lazy = true,
    keys = { { "<leader>tzn", ":TZNarrow<CR>", mode = { "v" } } },
    config = function()
      require("true-zen").setup({})
    end,
  },
  {
    "AckslD/nvim-FeMaco.lua",
    lazy = true,
    config = function()
      require("femaco").setup()
    end,
  },
}
