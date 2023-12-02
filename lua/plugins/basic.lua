return {
  {
    "coffebar/neovim-project",
    opts = {
      projects = {
        "~/.config/nvim/",
        "~/Desktop/lilith/*",
        "~/Desktop/xlboy/*",
        "~/Desktop/xlboy/__open-source__/*",
        "~/Desktop/xlboy/__open-source__/*",
        "D:\\project\\cpp\\*",
        "D:\\project\\nvim\\*",
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
}
