return {
  {
    "elijahmanor/export-to-vscode.nvim",
    lazy = true,
    keys = { { "<leader>vsc", function() require("export-to-vscode").launch() end, mode = "n" } },
  },
  {
    "folke/todo-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "TobinPalmer/rayso.nvim",
    cmd = "Rayso",
    opts = {
      open_cmd = "Arc",
      options = { theme = "breeze", padding = 16 },
    },
  },
  {
    "echasnovski/mini.bufremove",
    lazy = true,
    keys = {
      {
        "<leader>cc",
        function() require("mini.bufremove").delete(0, false) end,
        desc = "Delete Current Buffer",
      },
      {
        "<leader>ca",
        function()
          local bufremove = require("mini.bufremove")
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            bufremove.delete(bufnr, false)
          end
        end,
        desc = "Delete All Buffer",
      },
    },
  },
}
