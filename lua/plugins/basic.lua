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
        "D:\\project\\cpp\\*",
        "D:\\project\\nvim\\*",
        "C:\\Users\\Administrator\\.config\\*",
        "C:\\Users\\Administrator\\AppData\\Local\\nvim",
      },
    },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "Shatur/neovim-session-manager", lazy = true },
    },
    init = function()
      require("telescope").load_extension("neovim-project")
    end,
    lazy = false,
    priority = 100,
  },
  { "NMAC427/guess-indent.nvim", event = "BufRead", config = true },
  {
    "xlboy/telescope-recent-files",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension("recent_files")
    end,
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
      {
        "<leader><leader>",
        function()
          local t_extensions = require("telescope").extensions
          t_extensions.recent_files.pick({
            only_cwd = true,
            previewer = false,
            layout_config = { width = 110, height = 25 },
          })
        end,
        mode = "n",
      },
    },
  },
  { "nacro90/numb.nvim", event = "BufRead" },
  -- {
  --   "folke/neoconf.nvim",
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   -- event = "VeryLazy",
  --   opts = {},
  --   -- config = function() end,
  -- },
}
