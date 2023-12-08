return {
  {
    "LintaoAmons/scratch.nvim",
    event = "VimEnter",
    keys = {
      { "<leader>scce", "<cmd>ScratchEditConfig<cr>", desc = "sc - config edit" },
      { "<leader>scci", "<cmd>ScratchInitConfig<cr>", desc = "sc - config init" },
      { "<leader>scn",  "<cmd>Scratch<cr>",           desc = "sc - new scratch" },
      { "<leader>scN",  "<cmd>ScratchWithName<cr>",   desc = "sc - new scratch (named)" },
      { "<leader>sco",  "<cmd>ScratchOpen<cr>",       desc = "sc - open scratch" },
      { "<leader>scO",  "<cmd>ScratchOpenFzf<cr>",    desc = "sc - open scratch (fzf)" },
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
    keys = { {
      "<leader><leader>",
      function()
        local t_extensions = require("telescope").extensions
        t_extensions.recent_files.pick({
          only_cwd = true,
          previewer = false,
          layout_config = { width = 110, height = 25 },
        })
      end,
      mode = "n"
    } }
  },
}
