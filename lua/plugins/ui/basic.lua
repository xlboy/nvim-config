return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      {
        "<leader>udn",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    config = function()
      require("notify").setup({
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
      })
      vim.notify = require("notify")
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
  -- {
  --   "shellRaining/hlchunk.nvim",
  --   enabled = false,
  --   event = "UIEnter",
  --   init = function()
  --     vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, { pattern = "*", command = "EnableHL" })
  --
  --     require("hlchunk").setup({
  --       chunk = {
  --         enable = true,
  --         use_treesitter = true,
  --         style = { { fg = "#73daca" } },
  --       },
  --       indent = {
  --         enable = false,
  --         chars = { "·" },
  --         use_treesitter = false,
  --         style = { {} },
  --       },
  --       blank = { enable = false },
  --       line_num = { enable = true, use_treesitter = true },
  --     })
  --   end,
  -- },
}
