return {
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>scce", ":ScratchEditConfig<cr>", desc = "sc - config edit" },
      { "<leader>scci", ":ScratchInitConfig<cr>", desc = "sc - config init" },
      { "<leader>scn", ":Scratch<cr>", desc = "sc - new scratch" },
      { "<leader>scN", ":ScratchWithName<cr>", desc = "sc - new scratch (named)" },
      { "<leader>sco", ":ScratchOpen<cr>", desc = "sc - open scratch" },
      { "<leader>scO", ":ScratchOpenFzf<cr>", desc = "sc - open scratch (fzf)" },
    },
  },
  { "NMAC427/guess-indent.nvim", event = "BufRead", config = true },
  { "nacro90/numb.nvim", event = "BufRead" },
  -- {
  --   "folke/neoconf.nvim",
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   -- event = "VeryLazy",
  --   opts = {},
  --   -- config = function() end,
  -- },
}
