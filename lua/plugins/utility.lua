local t_extensions = require("telescope").extensions
local u = require("utils")

return {
  { "wakatime/vim-wakatime", event = "User Startup60s" },
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
    "axieax/urlview.nvim",
    config = true,
    keys = { { "<leader>tsu", ":UrlView<CR>", desc = "Open Url View" } },
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
    dependencies = { "kkharji/sqlite.lua" },
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
      { "y", "<Plug>(YankyYank)", mode = { "n", "x", "v" }, desc = "Yank text" },
    },
  },
}
