return {
  {
    "LintaoAmons/scratch.nvim",
    -- version = "~0.13.2",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>sc", desc = "[Scratch] ..." },
      { "<leader>scce", ":ScratchEditConfig<cr>", desc = "sc - config edit" },
      { "<leader>scci", ":ScratchInitConfig<cr>", desc = "sc - config init" },
      { "<leader>scn", ":Scratch<cr>", desc = "sc - new scratch" },
      { "<leader>scN", ":ScratchWithName<cr>", desc = "sc - new scratch (named)" },
      { "<leader>sco", ":ScratchOpen<cr>", desc = "sc - open scratch" },
      { "<leader>scO", ":ScratchOpenFzf<cr>", desc = "sc - open scratch (fzf)" },
    },
  },
}
