local t_extensions = require("telescope").extensions
local u = require("utils")

return {
  {
    "kazhala/close-buffers.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>cc", ":BDelete! this<CR>", desc = "Delete Current Buffer" },
      { "<leader>ca", ":BDelete! all<CR>", desc = "Delete All Buffer" },
      { "<leader>co", ":BDelete! other<CR>", desc = "Delete Other Buffer" },
      { "<leader>cn", ":BDelete! nameless<CR>", desc = "Delete Nameless Buffer" },
      {
        "<leader>cs",
        function()
          local suffix = vim.fn.input("Suffix: ")
          if suffix ~= "" then vim.cmd(":BDelete! regex=.*[.]" .. suffix) end
        end,
        desc = "Delete Specify Suffix Buffer",
      },
      {
        "<leader>cg",
        function()
          local pattern = vim.fn.input("Glob Pattern: ")
          if pattern ~= "" then vim.cmd(":BDelete! glob=" .. pattern) end
        end,
        desc = "Delete Specify Suffix Buffer",
      },
    },
  },
  {
    "elijahmanor/export-to-vscode.nvim",
    lazy = true,
    keys = {
      {
        "<leader>vsc",
        function()
          require("export-to-vscode").launch()
        end,
        mode = "n",
      },
    },
  },
  {
    "TobinPalmer/rayso.nvim",
    cmd = "Rayso",
    opts = {
      open_cmd = u.basic.os_pick("miedge.exe", "Arc"),
      options = { padding = 16, theme = "breeze" },
    },
  },
  {
    "chrishrb/gx.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      open_browser_app = u.basic.os_pick("powershell.exe", "open"),
      handlers = {
        plugin = true,
        github = true,
        package_json = true,
        search = true,
      },
      handler_options = { search_engine = "google" },
    },
  },
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    dependencies = { { "kkharji/sqlite.lua" } },
    opts = {
      ring = { storage = "sqlite", ignore_registers = { "0" } },
      highlight = { on_put = true, on_yank = true, timer = 150 },
      system_clipboard = { sync_with_ring = false },
    },
    keys = {
      {
        "<leader>tsy",
        function()
          t_extensions.yank_history.yank_history({})
        end,
        desc = "Open Yank History",
      },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
    },
  },
}
