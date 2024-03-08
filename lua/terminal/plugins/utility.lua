local t_extensions = require("telescope").extensions
local u = require("terminal.utils")

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
    "xlboy/urlview.nvim",
    config = true,
    keys = {
      {
        "<leader>tsu",
        function()
          local menu = { ["Current Buffer"] = "UrlView", ["Lazy"] = "UrlView lazy" }
          vim.ui.select(vim.tbl_keys(menu), { prompt = "[UrlView] Select Mode" }, function(type)
            if not type then return end
            vim.cmd(menu[type])
          end)
        end,
        desc = "[UrlView] Open Menu",
      },
    },
  },
  {
    "chrishrb/gx.nvim",
    version = "0.4.0",
    event = "User BufRead",
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
