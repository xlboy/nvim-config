local t_extensions = require("telescope").extensions
local u = require("utils")

return {
  {
    "kazhala/close-buffers.nvim",
    keys = {
      { "<leader>cc", "<cmd>BDelete! this<CR>", desc = "Delete Current Buffer" },
      { "<leader>ca", "<cmd>BDelete! all<CR>", desc = "Delete All Buffer" },
      { "<leader>co", "<cmd>BDelete! other<CR>", desc = "Delete Other Buffer" },
      { "<leader>cn", "<cmd>BDelete! nameless<CR>", desc = "Delete Nameless Buffer" },
      {
        "<leader>cs",
        function()
          local suffix = vim.fn.input("Suffix: ")
          if suffix ~= "" then vim.cmd("BDelete! regex=.*[.]" .. suffix) end
        end,
        desc = "Delete Specify Suffix Buffer",
      },
      {
        "<leader>cg",
        function()
          local pattern = vim.fn.input("Glob Pattern: ")
          if pattern ~= "" then vim.cmd("BDelete! glob=" .. pattern) end
        end,
        desc = "Delete Specify Suffix Buffer",
      },
    },
  },
  {
    "xlboy/vscode-opener.nvim",
    dependencies = { "prochri/telescope-all-recent.nvim" },
    keys = {
      {
        "<leader>vsc",
        "<cmd>lua require('vscode-opener').open_current_buf()<CR>",
        desc = "Open Current Buffer in VSCode",
      },
      {
        "<leader>vsm",
        "<cmd>lua require('vscode-opener').open()<CR>",
        desc = "Open VSCode Opener Menu",
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
    event = "BufRead",
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
