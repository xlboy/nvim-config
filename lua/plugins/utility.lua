return {
  {
    "elijahmanor/export-to-vscode.nvim",
    event = "BufReadPost",
    config = function()
      vim.keymap.set("n", "<leader>vsc", require("export-to-vscode").launch, {})
    end,
  },
  {
    "folke/todo-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
}
