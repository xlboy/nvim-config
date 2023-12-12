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
  {
    "coffebar/neovim-project",
    opts = {
      projects = {
        "~/.config/*",
        "~/Desktop/lilith/*",
        "~/Desktop/xlboy/*",
        "~/Desktop/xlboy/__open-source__/*",
        "~/Desktop/xlboy-project/__open-source__/*",
        "~/Desktop/xlboy-project/*",
        "D:/project/cpp/*",
        "D:/project/nvim/*",
        "C:/Users/Administrator/.config/*",
        "C:/Users/Administrator/AppData/Local/nvim",
        vim.fn.stdpath("data") .. "/lazy/*"
      },
    },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "Shatur/neovim-session-manager", lazy = true },
    },
    init = function() require("telescope").load_extension("neovim-project") end,
    lazy = false,
    priority = 100,
  },
  -- {
  --   "folke/neoconf.nvim",
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   -- event = "VeryLazy",
  --   opts = {},
  --   -- config = function() end,
  -- },
}
