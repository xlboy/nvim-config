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
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "UIEnter",
    main = "ibl",
    config = function()
      vim.cmd("highlight XlboyIndentScope guifg=#7bdfd0")
      require("ibl").setup({
        indent = { char = "│" },
        scope = {
          show_start = false,
          show_end = false,
          highlight = "XlboyIndentScope",
        },
        exclude = {
          buftypes = { "nofile", "terminal" },
          filetypes = { "help", "alpha", "dashboard", "lazy", "neogitstatus", "NvimTree", "neo-tree" },
        },
      })
    end,
  },
  {
    "dstein64/nvim-scrollview",
    event = "BufReadPre",
    opts = {
      on_startup = 1,
      winblend = 60,
      hide_on_intersect = 1,
      column = 1,
      current_only = 1,
      scrollview_auto_mouse = true,
      mode = "simple",
    },
  },
}
